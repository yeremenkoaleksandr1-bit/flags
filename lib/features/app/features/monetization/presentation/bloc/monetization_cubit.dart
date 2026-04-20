import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flags/features/app/features/monetization/presentation/bloc/monetization_state.dart';
import 'package:flags/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
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
    'NO_ADS_PRODUCT_ID',
    fallback: 'flagsup_no_ads_subscription',
  );

  final SharedPreferences _prefs;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final Random _random = Random();

  late final StreamSubscription<List<PurchaseDetails>> _purchaseSubscription;

  ProductDetails? _subscriptionProduct;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  Completer<void>? _interstitialLoadCompleter;
  Completer<void>? _rewardedLoadCompleter;
  bool _pendingPostLevelInterstitial = false;

  Future<void> _initialize() async {
    _loadInterstitialAd();
    _loadRewardedAd();

    final storeAvailable = await _inAppPurchase.isAvailable();
    if (!storeAvailable) {
      emit(
        state.copyWith(statusMessage: 'Store is unavailable on this device'),
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

    emit(state.copyWith(isPurchasePending: true, clearStatusMessage: true));

    final purchaseParam = PurchaseParam(productDetails: _subscriptionProduct!);
    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases() async {
    emit(state.copyWith(isPurchasePending: true, clearStatusMessage: true));
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

  Future<void> onFastModeRoundCompleted() async {
    if (state.isPremium) {
      return;
    }

    final completedRounds = (_prefs.getInt(_fastModeRoundsPrefsKey) ?? 0) + 1;
    if (completedRounds < 5) {
      _prefs.setInt(_fastModeRoundsPrefsKey, completedRounds);
      return;
    }

    _prefs.setInt(_fastModeRoundsPrefsKey, 0);
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

    logger.i(_rewardedUnitId);
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
      'ADMOB_INTERSTITIAL_ID_',
      fallback: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-3940256099942544/4411468910',
    );
  }

  String get _rewardedUnitId {
    return dotenv.get(
      'ADMOB_REWARDED_ID_',
      fallback: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-3940256099942544/4411468910',
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
