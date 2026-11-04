import 'ui_image_assets.dart';

class AssetsImage {
  const AssetsImage._({
    required this.cash,
    required this.heart,
    required this.hand,
    required this.logo,
    required this.timer,
    required this.winnerCup,
    required this.lock,
    required this.arrowUp,
    required this.checkmark,
    required this.circle,
    required this.sliderEnd,
    required this.tickWhite,
    required this.cross,
    required this.removeAds,
  });

  final UIImageAsset cash;
  final UIImageAsset heart;
  final UIImageAsset hand;
  final UIImageAsset lock;

  final UIImageAsset logo;

  final UIImageAsset timer;
  final UIImageAsset winnerCup;

  final UIImageAsset arrowUp;
  final UIImageAsset checkmark;
  final UIImageAsset circle;
  final UIImageAsset sliderEnd;
  final UIImageAsset tickWhite;
  final UIImageAsset cross;
  final UIImageAsset removeAds;

  static Future<AssetsImage> initialize() async {
    return AssetsImage._(
      cash: await UIImageAsset.load("money.png"),
      heart: await UIImageAsset.load("heart.png"),
      hand: await UIImageAsset.load("hand.png"),
      logo: await UIImageAsset.load("logo.png"),
      timer: await UIImageAsset.load("timer.png"),
      winnerCup: await UIImageAsset.load("winner_cup.png"),
      lock: await UIImageAsset.load("locked.png"),
      arrowUp: await UIImageAsset.load("ui/arrowUp.png"),
      checkmark: await UIImageAsset.load("ui/checkmark.png"),
      circle: await UIImageAsset.load("ui/circle.png"),
      sliderEnd: await UIImageAsset.load("ui/sliderEnd.png"),
      tickWhite: await UIImageAsset.load("ui/tickWhite.png"),
      cross: await UIImageAsset.load("ui/crossWhite.png"),
      removeAds: await UIImageAsset.load("ui/remove_ads.png"),
    );
  }
}
