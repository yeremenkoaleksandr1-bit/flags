import 'dart:math';
import 'package:flags/ui/clouds/cloud_model.dart';
import 'package:flags/ui/clouds/clouds_prefabs.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CloudsPainter extends StatefulWidget {
  static const _cloudCount = 10;
  static const _spawnPadding = 10.0;
  static const _speedFactor = 50.0;

  const CloudsPainter({super.key});

  @override
  State<CloudsPainter> createState() => _CloudsPainterState();
}

class _CloudsPainterState extends State<CloudsPainter>
    with TickerProviderStateMixin {
  final _random = Random();
  final List<Cloud> _clouds = [];

  late Ticker _ticker;
  Size _viewportSize = Size.zero;
  Duration _lastFrameTime = Duration.zero;

  @override
  void initState() {
    super.initState();

    _ticker = createTicker((elapsed) {
      if (_lastFrameTime == Duration.zero) {
        _lastFrameTime = elapsed;
      }
      final deltaTime = (elapsed - _lastFrameTime).inMicroseconds / 1e6;
      _lastFrameTime = elapsed;

      if (_viewportSize.isEmpty || !mounted) {
        return;
      }

      _updateClouds(deltaTime);
      setState(() {});
    });

    _ticker.start();
  }

  void _updateClouds(double deltaTime) {
    for (final cloud in _clouds) {
      cloud.updatePosition(
        deltaTime * cloud.speed * CloudsPainter._speedFactor,
      );
      _matchCloudPosition(cloud);
    }
  }

  void _ensureClouds(Size size) {
    if (_viewportSize == size && _clouds.isNotEmpty) {
      return;
    }

    final previousSize = _viewportSize;
    _viewportSize = size;

    if (_clouds.isEmpty) {
      _clouds.addAll(
        List.generate(CloudsPainter._cloudCount, (_) => _createCloud()),
      );
      return;
    }

    if (previousSize.isEmpty) {
      for (final cloud in _clouds) {
        _placeCloud(cloud, randomizeX: true, randomizeY: true);
      }
      return;
    }

    final widthRatio = size.width / previousSize.width;
    final heightRatio = size.height / previousSize.height;

    for (final cloud in _clouds) {
      cloud.position = Offset(
        cloud.position.dx * widthRatio,
        cloud.position.dy * heightRatio,
      );
      _clampCloudY(cloud);
    }
  }

  Cloud _createCloud() {
    final cloud = Cloud(path: cloudsPrefabs.random(_random));
    _randomizeCloudParams(cloud);
    _placeCloud(cloud, randomizeX: true, randomizeY: true);
    return cloud;
  }

  void _matchCloudPosition(Cloud cloud) {
    final width = _viewportSize.width;
    final leftBoundary =
        -(cloud.bounds.width * cloud.scale) - CloudsPainter._spawnPadding;
    final rightBoundary = width + CloudsPainter._spawnPadding;

    if (cloud.position.dx > rightBoundary || cloud.position.dx < leftBoundary) {
      _randomizeCloudParams(cloud);
      _placeCloud(cloud, randomizeX: false, randomizeY: true);
    }
  }

  void _placeCloud(
    Cloud cloud, {
    required bool randomizeX,
    required bool randomizeY,
  }) {
    final scaledBounds = _scaledBounds(cloud);
    final maxX = (_viewportSize.width - scaledBounds.width).clamp(
      0.0,
      double.infinity,
    );

    final dx = randomizeX
        ? _random.nextDouble() * maxX
        : (cloud.direction ? -scaledBounds.width : _viewportSize.width);

    final dy = randomizeY
        ? _randomY(scaledBounds.height)
        : cloud.position.dy.clamp(
            scaledBounds.height,
            _viewportSize.height - scaledBounds.height,
          );

    cloud.position = Offset(dx, dy);
  }

  void _clampCloudY(Cloud cloud) {
    final scaledBounds = _scaledBounds(cloud);
    cloud.position = Offset(
      cloud.position.dx,
      _randomY(scaledBounds.height, current: cloud.position.dy),
    );
  }

  double _randomY(double cloudHeight, {double? current}) {
    final minY = cloudHeight;
    final maxY = (_viewportSize.height - cloudHeight).clamp(
      minY,
      double.infinity,
    );

    if (current != null) {
      return current.clamp(minY, maxY);
    }

    if (minY == maxY) {
      return minY;
    }

    return minY + (_random.nextDouble() * (maxY - minY));
  }

  Rect _scaledBounds(Cloud cloud) {
    return Rect.fromLTWH(
      0,
      0,
      cloud.bounds.width * cloud.scale,
      cloud.bounds.height * cloud.scale,
    );
  }

  void _randomizeCloudParams(Cloud cloud) {
    cloud.direction = _random.nextBool();
    cloud.speed = _random.nextDouble().clamp(0.5, 0.8);
    cloud.transparency = _random.nextDouble().clamp(0.4, 1.0);
    cloud.scale = (_random.nextDouble() * 1.5).clamp(0.5, 1.5);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        if (!size.isEmpty) {
          _ensureClouds(size);
        }

        return CustomPaint(
          painter: _CloudsPainter(clouds: _clouds),
          size: size,
        );
      },
    );
  }
}

class _CloudsPainter extends CustomPainter {
  _CloudsPainter({required this.clouds});

  final List<Cloud> clouds;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final cloud in clouds) {
      canvas.save();

      paint.color = Colors.white.withValues(alpha: cloud.transparency);

      canvas.translate(cloud.position.dx, cloud.position.dy);

      canvas.scale(cloud.direction ? 1 : -1, 1);

      canvas.scale(cloud.scale);

      canvas.drawPath(cloud.path, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_CloudsPainter oldDelegate) {
    return true;
  }
}
