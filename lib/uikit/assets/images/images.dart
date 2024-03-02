import 'ui_image_assets.dart';

class AssetsImage {
  const AssetsImage._({
    required this.background,
    required this.yellowButton,
    required this.greyButton,
    required this.cash,
    required this.heart,
    required this.hand,
    required this.logo,
    required this.timer,
    required this.winnerCup,
    required this.panel,
    required this.lock,
    required this.arrowUp,
    required this.checkmark,
    required this.circle,
    required this.sliderEnd,
    required this.tickWhite,
    required this.cross,
  });

  final UIImageAsset background;
  final UIImageAsset yellowButton;
  final UIImageAsset greyButton;

  final UIImageAsset panel;

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

  static Future<AssetsImage> initialize() async {
    return AssetsImage._(
      background: await UIImageAsset.load("background.png"),
      yellowButton: await UIImageAsset.load("yellow_button00.png"),
      greyButton: await UIImageAsset.load("grey_button08.png"),
      cash: await UIImageAsset.load("money.png"),
      heart: await UIImageAsset.load("heart.png"),
      hand: await UIImageAsset.load("hand.png"),
      logo: await UIImageAsset.load("logo.png"),
      timer: await UIImageAsset.load("timer.png"),
      winnerCup: await UIImageAsset.load("winner_cup.png"),
      panel: await UIImageAsset.load("ui/panel.png"),
      lock: await UIImageAsset.load("locked.png"),
      arrowUp: await UIImageAsset.load("ui/arrowUp.png"),
      checkmark: await UIImageAsset.load("ui/checkmark.png"),
      circle: await UIImageAsset.load("ui/circle.png"),
      sliderEnd: await UIImageAsset.load("ui/sliderEnd.png"),
      tickWhite: await UIImageAsset.load("ui/tickWhite.png"),
      cross: await UIImageAsset.load("ui/crossWhite.png"),
    );
  }
}
