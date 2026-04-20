# flags

## Environment

Monetization identifiers are loaded from `.env` via `flutter_dotenv`.

Create `.env` in the project root from `.env.example`:

```env
ADMOB_ANDROID_APP_ID=ca-app-pub-...~...
ADMOB_IOS_APP_ID=ca-app-pub-...~...
NO_ADS_PRODUCT_ID=your_store_product_id
ADMOB_INTERSTITIAL_ID=ca-app-pub-.../...
ADMOB_REWARDED_ID=ca-app-pub-.../...
```

Android reads `ADMOB_ANDROID_APP_ID` during native build.

iOS generates [ios/Flutter/AdMob.xcconfig](/E:/work/flags/ios/Flutter/AdMob.xcconfig:1) from `.env` during Xcode build and reads `ADMOB_IOS_APP_ID` from there:

```env
ADMOB_IOS_APP_ID=ca-app-pub-...~...
```

If you leave test ids in place, debug builds will still work, but production ads should use your real AdMob app and unit identifiers.
