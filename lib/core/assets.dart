// import 'dart:ui';
//
// import 'package:flame/components.dart';
// import 'package:flame/flame.dart';
//
// class Assets {
//   const Assets._();
//
//   static ISpriteAsset background = SpriteAsset(path: 'background.png');
//   static ISpriteAsset logo = SpriteAsset(path: 'logo.png');
//
//   static List<ISpriteAsset> sprites = [
//     background,
//     logo,
//   ];
//
//   static Future<void> init() async {
//     final totalSprites = [
//       ...sprites,
//     ];
//
//     final assetsPaths = totalSprites.map((e) => e.path).toList();
//
//     await Flame.images.loadAll(assetsPaths);
//
//     for (final sprite in totalSprites) {
//       await (sprite as SpriteAsset).init();
//     }
//   }
// }
//
// abstract interface class ISpriteAsset {
//   String get path;
//
//   Sprite get sprite;
// }
//
// class SpriteAsset implements ISpriteAsset {
//   @override
//   final String path;
//
//   @override
//   late final Sprite sprite;
//
//   SpriteAsset({
//     required this.path,
//   });
//
//   Future<void> init() async {
//     sprite = await Sprite.load(path);
//
//     sprite.paint
//       ..isAntiAlias = true
//       ..filterQuality = FilterQuality.high;
//   }
// }
