import 'dart:math';
import 'package:flags/ui/clouds/cloud_model.dart';
import 'package:flags/ui/clouds/clouds_prefabs.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CloudsPainter extends StatefulWidget {
  const CloudsPainter({super.key});

  @override
  State<CloudsPainter> createState() => _CloudsPainterState();
}

class _CloudsPainterState extends State<CloudsPainter>
    with TickerProviderStateMixin {
  final random = Random();

  Size get mq => MediaQuery.of(context).size;

  late final List<Cloud> clouds = List.generate(
    10,
    (i) {
      final cloud = Cloud(
        path: cloudsPrefabs.random(random),
      );

      cloud.position = Offset(
        random.nextDouble() * mq.width,
        random.nextDouble() * mq.height,
      );



      setRandomCloudParams(cloud);

      return cloud;
    },
  );

  late Ticker _ticker;
  Duration _lastFrameTime = Duration.zero;
  double deltaTime = 0.0;

  @override
  void initState() {
    super.initState();

    _ticker = createTicker((elapsed) {
      if (_lastFrameTime == Duration.zero) {
        _lastFrameTime = elapsed;
      }
      deltaTime = (elapsed - _lastFrameTime).inMicroseconds / 1e6;
      _lastFrameTime = elapsed;

      onAnimationUpdate(deltaTime);
      setState(() {});
    });

    _ticker.start();
  }

  void onAnimationUpdate(double deltaTime) {
    for (final cloud in clouds) {
      cloud.updatePosition(deltaTime * cloud.speed * 50);
      matchCloudPosition(cloud);
    }
  }

  void matchCloudPosition(Cloud cloud) {
    if (cloud.position.dx > (mq.width + 10) ||
        cloud.position.dx < -cloud.bounds.width - 10) {
      final randomY = random.nextDouble() * mq.height;

      cloud.position = Offset(
        cloud.direction ? -cloud.bounds.width : mq.width,
        randomY.clamp(cloud.bounds.height, mq.height - cloud.bounds.height),
      );

      setRandomCloudParams(cloud);
    }
  }

  void setRandomCloudParams(Cloud cloud) {
    cloud.direction = random.nextBool();
    cloud.speed = random.nextDouble().clamp(0.5, 0.8);
    cloud.transparency = random.nextDouble().clamp(0.4, 1);
    cloud.scale = (random.nextDouble() * 1.5).clamp(0.5, 1.5);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CloudsPainter(
        clouds: clouds,
      ),
    );
  }
}

class _CloudsPainter extends CustomPainter {
  _CloudsPainter({required this.clouds});

  final List<Cloud> clouds;

  @override
  void paint(Canvas canvas, Size size) {
    for (final cloud in clouds) {
      canvas.save();

      final paint = Paint()
        ..color = Colors.white.withValues(alpha: cloud.transparency)
        ..style = PaintingStyle.fill;

      canvas.translate(cloud.position.dx, cloud.position.dy);

      canvas.scale(
        cloud.direction ? 1 : -1,
        1,
      );

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
