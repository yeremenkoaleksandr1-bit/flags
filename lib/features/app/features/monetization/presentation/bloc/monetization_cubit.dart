import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'monetization_state.dart';

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
  static const String _noAdsProductId = String.fromEnvironment(
    'NO_ADS_PRODUCT_ID',
    defaultValue: 'flagsup_no_ads_subscription',
  );

  final SharedPreferences _prefs;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final Random _random = Random();

  late final StreamSubscription<List<PurchaseDetails>> _purchaseSubscription;

  ProductDetails? _subscriptionProduct;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _pendingPostLevelInterstitial = false;

  Future<void> _initialize() async {
    await MobileAds.instance.initialize();
    _loadInterstitialAd();
    _loadRewardedAd();

    final storeAvailable = await _inAppPurchase.isAvailable();
    if (!storeAvailable) {
      emit(
        state.copyWith(
          statusMessage: 'Store is unavailable on this device',
        ),
      );
      return;
    }

    final productResponse = await _inAppPurchase.queryProductDetails({
      _noAdsProductId,
    });

    if (productResponse.productDetails.isNotEmpty) {
      _subscriptionProduct = productResponse.productDetails.first;
      emit(
        state.copyWith(
          subscriptionPriceLabel: _subscriptionProduct!.price,
          clearStatusMessage: true,
        ),
      );
    }
  }

  Future<void> buyNoAdsSubscription() async {
    if (_subscriptionProduct == null) {
      emit(
        state.copyWith(
          statusMessage: 'Create the subscription in Google Play Console first',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isPurchasePending: true,
        clearStatusMessage: true,
      ),
    );

    final purchaseParam = PurchaseParam(productDetails: _subscriptionProduct!);
    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases() async {
    emit(
      state.copyWith(
        isPurchasePending: true,
        clearStatusMessage: true,
      ),
    );
    await _inAppPurchase.restorePurchases();
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

    if (completedLevels < 5) {
      return;
    }

    _prefs.setInt(_completedLevelsPrefsKey, 0);
    _pendingPostLevelInterstitial = _random.nextBool();
  }

  Future<void> consumePostLevelAdOpportunity() async {
    if (state.isPremium || !_pendingPostLevelInterstitial) {
      return;
    }

    _pendingPostLevelInterstitial = false;
    await _showInterstitialAd();
  }

  Future<bool> claimDoubleReward() async {
    if (state.isPremium) {
      return true;
    }

    return _showRewardedAd();
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.productID != _noAdsProductId) {
        continue;
      }

      if (purchase.status == PurchaseStatus.pending) {
        emit(state.copyWith(isPurchasePending: true));
      }

      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        _prefs.setBool(_premiumPrefsKey, true);
        emit(
          state.copyWith(
            isPremium: true,
            isPurchasePending: false,
            statusMessage: 'No Ads activated',
          ),
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

      if (purchase.pendingCompletePurchase) {
        unawaited(_inAppPurchase.completePurchase(purchase));
      }
    }
  }

  void _handlePurchaseStreamError(Object error) {
    emit(
      state.copyWith(
        isPurchasePending: false,
        statusMessage: error.toString(),
      ),
    );
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd?.dispose();
          _interstitialAd = ad..setImmersiveMode(true);
        },
        onAdFailedToLoad: (_) {
          _interstitialAd = null;
        },
      ),
    );
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: _rewardedUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd?.dispose();
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (_) {
          _rewardedAd = null;
        },
      ),
    );
  }

  Future<void> _showInterstitialAd() async {
    final ad = _interstitialAd;
    if (ad == null) {
      _loadInterstitialAd();
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
    final ad = _rewardedAd;
    if (ad == null) {
      _loadRewardedAd();
      return false;
    }

    final completer = Completer<bool>();
    _rewardedAd = null;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadRewardedAd();
        if (!completer.isCompleted) {
          completer.complete(false);
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
        if (!completer.isCompleted) {
          completer.complete(true);
        }
      },
    );

    return completer.future;
  }

  String get _interstitialUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-3940256099942544/4411468910';
    }

    return const String.fromEnvironment(
      'ADMOB_INTERSTITIAL_ID',
      defaultValue: 'ca-app-pub-3940256099942544/1033173712',
    );
  }

  String get _rewardedUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5224354917'
          : 'ca-app-pub-3940256099942544/1712485313';
    }

    return const String.fromEnvironment(
      'ADMOB_REWARDED_ID',
      defaultValue: 'ca-app-pub-3940256099942544/5224354917',
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
