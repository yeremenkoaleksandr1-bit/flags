import 'dart:async';
import 'dart:io';

import 'package:flags/core/flutter_engine.dart';
import 'package:flags/features/app/features/monetization/presentation/bloc/monetization_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_2_wrappers.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class MonetizationCubit extends Cubit<MonetizationState> {
  MonetizationCubit(this._prefs)
    : super(
        MonetizationState.initial(
          isPremium: _prefs.getBool(_premiumPrefsKey) ?? false,
        ),
      ) {
    _purchaseSubscription = _inAppPurchase.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: _handlePurchaseStreamError,
    );
    unawaited(_initialize());
  }

  static const String _premiumPrefsKey = 'monetization.isPremium';
  static const String _completedLevelsPrefsKey =
      'monetization.completedLevelsSinceInterstitial';
  static const String _fastModeRoundsPrefsKey =
      'monetization.fastModeRoundsSinceInterstitial';
  static final String _noAdsProductId = dotenv.get(
    Platform.isAndroid ? "NO_ADS_PRODUCT_ID" : "NO_ADS_PRODUCT_IOS_ID",
    fallback: 'remove-ads',
  );

  final SharedPreferences _prefs;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  late final StreamSubscription<List<PurchaseDetails>> _purchaseSubscription;

  ProductDetails? _noAdsProduct;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  Completer<void>? _interstitialLoadCompleter;
  Completer<void>? _rewardedLoadCompleter;
  Completer<List<PurchaseDetails>>? _restorePurchasesCompleter;
  bool _pendingPostLevelInterstitial = false;
  String? _storeKitFallbackError;

  Future<void> _initialize() async {
    _logStoreKit('Initializing. productId=$_noAdsProductId');
    final storeAvailable = await _inAppPurchase.isAvailable();
    _logStoreKit('Store available=$storeAvailable');
    if (!storeAvailable) {
      emit(
        state.copyWith(
          isProductLoading: false,
          isProductAvailable: false,
          statusMessage: 'Store is unavailable on this device',
        ),
      );
      return;
    }

    if (!state.isPremium) {
      _loadInterstitialAd();
      _loadRewardedAd();
    }

    await _loadNoAdsProduct();
  }

  Future<void> _loadNoAdsProduct() async {
    ProductDetailsResponse? productResponse;

    for (var attempt = 0; attempt < 3; attempt++) {
      _logStoreKit('Query product attempt=${attempt + 1}');
      productResponse = await _queryNoAdsProductDetails();
      _logProductResponse(productResponse);

      if (productResponse.error == null ||
          !productResponse.error!.message.toLowerCase().contains(
            'failed to get response from platform',
          )) {
        break;
      }

      if (attempt < 2) {
        await Future<void>.delayed(Duration(seconds: attempt + 1));
      }
    }

    productResponse ??= await _queryNoAdsProductDetails();

    if (productResponse.error != null) {
      _logStoreKit('Trying StoreKit wrapper fallback');
      final fallbackProduct = await _loadNoAdsProductFromStoreKitWrapper();
      if (fallbackProduct != null) {
        _logStoreKit('Fallback found product=${fallbackProduct.id}');
        _setNoAdsProductAvailable(fallbackProduct);
        return;
      }

      emit(
        state.copyWith(
          isProductLoading: false,
          isProductAvailable: false,
          statusMessage:
              '${productResponse.error!.message}. Product: $_noAdsProductId${_storeKitFallbackError == null ? '' : '. Fallback: $_storeKitFallbackError'}',
        ),
      );
      return;
    }

    if (productResponse.productDetails.isNotEmpty) {
      _logStoreKit(
        'Product found=${productResponse.productDetails.first.id} '
        'price=${productResponse.productDetails.first.price}',
      );
      _setNoAdsProductAvailable(productResponse.productDetails.first);
      return;
    }

    emit(
      state.copyWith(
        isProductLoading: false,
        isProductAvailable: false,
        statusMessage: productResponse.notFoundIDs.isEmpty
            ? 'No Ads is currently unavailable. Please try again later.'
            : 'No Ads product was not found: ${productResponse.notFoundIDs.join(', ')}',
      ),
    );
  }

  Future<ProductDetailsResponse> _queryNoAdsProductDetails() async {
    return _inAppPurchase
        .queryProductDetails({_noAdsProductId})
        .timeout(
          const Duration(seconds: 8),
          onTimeout: () => ProductDetailsResponse(
            productDetails: const [],
            notFoundIDs: const [],
            error: IAPError(
              source: 'app_store',
              code: 'storekit_timeout',
              message: 'StoreKit product request timed out',
            ),
          ),
        );
  }

  Future<ProductDetails?> _loadNoAdsProductFromStoreKitWrapper() async {
    if (!Platform.isIOS) {
      return null;
    }

    _storeKitFallbackError = null;

    try {
      final supportsStoreKit2 = await SKRequestMaker.supportsStoreKit2()
          .timeout(const Duration(seconds: 3), onTimeout: () => false);
      if (supportsStoreKit2) {
        final products = await SK2Product.products([
          _noAdsProductId,
        ]).timeout(const Duration(seconds: 8), onTimeout: () => const []);
        _logStoreKit(
          'StoreKit2 products=${products.map((e) => e.id).toList()}',
        );
        if (products.isNotEmpty) {
          return AppStoreProduct2Details.fromSK2Product(products.first);
        }
      }
    } catch (error) {
      _storeKitFallbackError = 'StoreKit2 $error';
    }

    try {
      final response = await SKRequestMaker()
          .startProductRequest([
            _noAdsProductId,
          ])
          .timeout(const Duration(seconds: 8));
      _logStoreKit(
        'StoreKit1 products=${response.products.map((e) => e.productIdentifier).toList()} '
        'invalid=${response.invalidProductIdentifiers}',
      );
      if (response.products.isNotEmpty) {
        return AppStoreProductDetails.fromSKProduct(response.products.first);
      }
    } catch (error) {
      _storeKitFallbackError = [
        if (_storeKitFallbackError != null) _storeKitFallbackError,
        'StoreKit1 $error',
      ].join('; ');
    }

    return null;
  }

  void _logProductResponse(ProductDetailsResponse response) {
    _logStoreKit(
      'queryProductDetails products=${response.productDetails.map((e) => e.id).toList()} '
      'notFound=${response.notFoundIDs} '
      'error=${response.error == null ? null : '${response.error!.code}: ${response.error!.message}'}',
    );
  }

  void _logStoreKit(String message) {
    if (!Platform.isIOS) {
      return;
    }

    debugPrint('[StoreKit] $message');
  }

  void _setNoAdsProductAvailable(ProductDetails product) {
    _noAdsProduct = product;
    emit(
      state.copyWith(
        isProductLoading: false,
        isProductAvailable: true,
        productPriceLabel: _noAdsProduct!.price,
        clearStatusMessage: true,
      ),
    );
  }

  Future<void> buyNoAdsSubscription(BuildContext context) async {
    if (dotenv.getBool("IS_DEBUG", fallback: false)) {
      await _activatePremiumLocally(
        statusMessage: 'No Ads activated automatically in debug mode',
      );
      FlutterEngine.widgetPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
      return;
    }

    if (_noAdsProduct == null) {
      emit(
        state.copyWith(
          isProductLoading: false,
          isProductAvailable: false,
          statusMessage:
              'No Ads is currently unavailable. Please try again later.',
        ),
      );
      return;
    }

    emit(state.copyWith(isPurchasePending: true, clearStatusMessage: true));

    final purchaseParam = PurchaseParam(productDetails: _noAdsProduct!);

    try {
      final launched = await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );

      if (!launched) {
        emit(
          state.copyWith(
            isPurchasePending: false,
            statusMessage: 'Purchase flow was not started',
          ),
        );
        return;
      }
    } catch (error) {
      emit(
        state.copyWith(
          isPurchasePending: false,
          statusMessage: error.toString(),
        ),
      );
      return;
    }

    FlutterEngine.widgetPostFrameCallback((_) {
      Navigator.of(context).pop();
    });
  }

  Future<void> restorePurchases() async {
    emit(state.copyWith(isPurchasePending: true, clearStatusMessage: true));
    await _syncPremiumWithStoreAccount(
      restoredMessage: 'No Ads restored for this store account',
      missingMessage:
          'No previous No Ads purchase found for this store account',
    );
  }

  void resetPurchaseDialogState() {
    emit(
      state.copyWith(
        isPurchasePending: false,
        clearStatusMessage: true,
      ),
    );
  }

  Future<void> _activatePremiumLocally({required String statusMessage}) async {
    await _prefs.setBool(_premiumPrefsKey, true);
    emit(
      state.copyWith(
        isPremium: true,
        isPurchasePending: false,
        statusMessage: statusMessage,
      ),
    );
  }

  Future<void> _deactivatePremiumLocally({String? statusMessage}) async {
    await _prefs.setBool(_premiumPrefsKey, false);
    emit(
      state.copyWith(
        isPremium: false,
        isPurchasePending: false,
        statusMessage: statusMessage,
      ),
    );
  }

  Future<void> _syncPremiumWithStoreAccount({
    String? restoredMessage,
    String? missingMessage,
  }) async {
    _restorePurchasesCompleter ??= Completer<List<PurchaseDetails>>();

    try {
      await _inAppPurchase.restorePurchases();

      final purchases = await _restorePurchasesCompleter!.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () => const <PurchaseDetails>[],
      );

      final ownsNoAds = purchases.any(
        (purchase) =>
            purchase.productID == _noAdsProductId &&
            (purchase.status == PurchaseStatus.purchased ||
                purchase.status == PurchaseStatus.restored),
      );

      if (ownsNoAds) {
        await _activatePremiumLocally(
          statusMessage:
              restoredMessage ?? state.statusMessage ?? 'No Ads active',
        );
        return;
      }

      await _deactivatePremiumLocally(statusMessage: missingMessage);
    } catch (error) {
      emit(
        state.copyWith(
          isPurchasePending: false,
          statusMessage: 'Failed to restore purchases: $error',
        ),
      );
    } finally {
      _restorePurchasesCompleter = null;
    }
  }

  Future<void> onGameOverAdOpportunity() async {
    if (state.isPremium) {
      return;
    }

    await _showInterstitialAd();
  }

  void registerLevelCompleted() {
    if (state.isPremium) {
      return;
    }

    final completedLevels = (_prefs.getInt(_completedLevelsPrefsKey) ?? 0) + 1;
    _prefs.setInt(_completedLevelsPrefsKey, completedLevels);

    if (completedLevels < 3) {
      return;
    }

    _prefs.setInt(_completedLevelsPrefsKey, 0);
    _pendingPostLevelInterstitial = true;
  }

  Future<void> consumePostLevelAdOpportunity() async {
    if (state.isPremium || !_pendingPostLevelInterstitial) {
      return;
    }

    _pendingPostLevelInterstitial = false;
    await _showInterstitialAd();
  }

  Future<void> onFastModeRoundCompleted() async {
    if (state.isPremium) {
      return;
    }

    final completedRounds = (_prefs.getInt(_fastModeRoundsPrefsKey) ?? 0) + 1;
    if (completedRounds < 3) {
      _prefs.setInt(_fastModeRoundsPrefsKey, completedRounds);
      return;
    }

    _prefs.setInt(_fastModeRoundsPrefsKey, 0);
    await _showInterstitialAd();
  }

  Future<bool> claimDoubleReward() async {
    return _showRewardedAd();
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    if (_restorePurchasesCompleter != null &&
        !_restorePurchasesCompleter!.isCompleted) {
      _restorePurchasesCompleter!.complete(
        List<PurchaseDetails>.unmodifiable(purchases),
      );
    }

    for (final purchase in purchases) {
      if (purchase.productID != _noAdsProductId) {
        continue;
      }

      if (purchase.status == PurchaseStatus.pending) {
        emit(state.copyWith(isPurchasePending: true));
      }

      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        unawaited(
          _activatePremiumLocally(statusMessage: 'No Ads activated'),
        );
      }

      if (purchase.status == PurchaseStatus.error) {
        emit(
          state.copyWith(
            isPurchasePending: false,
            statusMessage: purchase.error?.message ?? 'Purchase failed',
          ),
        );
      }

      if (purchase.status == PurchaseStatus.canceled) {
        emit(
          state.copyWith(
            isPurchasePending: false,
            statusMessage: 'Purchase canceled',
          ),
        );
      }

      if (purchase.pendingCompletePurchase) {
        unawaited(_inAppPurchase.completePurchase(purchase));
      }
    }
  }

  void _handlePurchaseStreamError(Object error) {
    emit(
      state.copyWith(isPurchasePending: false, statusMessage: error.toString()),
    );
  }

  void _loadInterstitialAd() {
    _interstitialLoadCompleter ??= Completer<void>();

    InterstitialAd.load(
      adUnitId: _interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd?.dispose();
          _interstitialAd = ad..setImmersiveMode(true);
          if (_interstitialLoadCompleter != null &&
              !_interstitialLoadCompleter!.isCompleted) {
            _interstitialLoadCompleter!.complete();
          }
          _interstitialLoadCompleter = null;
        },
        onAdFailedToLoad: (_) {
          _interstitialAd = null;
          if (_interstitialLoadCompleter != null &&
              !_interstitialLoadCompleter!.isCompleted) {
            _interstitialLoadCompleter!.complete();
          }
          _interstitialLoadCompleter = null;
        },
      ),
    );
  }

  void _loadRewardedAd() {
    _rewardedLoadCompleter ??= Completer<void>();

    RewardedAd.load(
      adUnitId: _rewardedUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd?.dispose();
          _rewardedAd = ad;
          if (_rewardedLoadCompleter != null &&
              !_rewardedLoadCompleter!.isCompleted) {
            _rewardedLoadCompleter!.complete();
          }
          _rewardedLoadCompleter = null;
        },
        onAdFailedToLoad: (_) {
          _rewardedAd = null;
          if (_rewardedLoadCompleter != null &&
              !_rewardedLoadCompleter!.isCompleted) {
            _rewardedLoadCompleter!.complete();
          }
          _rewardedLoadCompleter = null;
        },
      ),
    );
  }

  Future<void> _showInterstitialAd() async {
    final ad = await _prepareInterstitialAd();
    if (ad == null) {
      return;
    }

    final completer = Completer<void>();
    _interstitialAd = null;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadInterstitialAd();
        if (!completer.isCompleted) {
          completer.complete();
        }
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _loadInterstitialAd();
        if (!completer.isCompleted) {
          completer.complete();
        }
      },
    );

    ad.show();
    await completer.future;
  }

  Future<bool> _showRewardedAd() async {
    final ad = await _prepareRewardedAd();
    if (ad == null) {
      return false;
    }

    final completer = Completer<bool>();
    var rewardEarned = false;
    _rewardedAd = null;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadRewardedAd();
        if (!completer.isCompleted) {
          completer.complete(rewardEarned);
        }
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _loadRewardedAd();
        if (!completer.isCompleted) {
          completer.complete(false);
        }
      },
    );

    ad.setImmersiveMode(true);
    ad.show(
      onUserEarnedReward: (_, __) {
        rewardEarned = true;
      },
    );

    return completer.future;
  }

  Future<InterstitialAd?> _prepareInterstitialAd() async {
    if (_interstitialAd != null) {
      return _interstitialAd;
    }

    await _showAdPlaceholderWhile(() async {
      _loadInterstitialAd();
      await _interstitialLoadCompleter?.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () {},
      );
    });

    return _interstitialAd;
  }

  Future<RewardedAd?> _prepareRewardedAd() async {
    if (_rewardedAd != null) {
      return _rewardedAd;
    }

    await _showAdPlaceholderWhile(() async {
      _loadRewardedAd();
      await _rewardedLoadCompleter?.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () {},
      );
    });

    return _rewardedAd;
  }

  Future<void> _showAdPlaceholderWhile(Future<void> Function() action) async {
    await EasyLoading.show(status: 'Searching for ad...');
    try {
      await action();
    } finally {
      await EasyLoading.dismiss();
    }
  }

  String get _interstitialUnitId {
    return dotenv.get(
      Platform.isAndroid
          ? 'ADMOB_INTERSTITIAL_ID'
          : 'ADMOB_INTERSTITIAL_IOS_ID',
    );
  }

  String get _rewardedUnitId {
    return dotenv.get(
      Platform.isAndroid ? 'ADMOB_REWARDED_ID' : 'ADMOB_REWARDED_IOS_ID',
    );
  }

  @override
  Future<void> close() async {
    await _purchaseSubscription.cancel();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    await super.close();
  }
}
