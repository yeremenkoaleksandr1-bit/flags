import 'dart:math' as math;

import 'package:flags/domain/domain.dart';
import 'package:flags/features/app/features/shop/presentation/components/shop_item.view.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContinentsSlider extends StatefulWidget {
  const ContinentsSlider({
    super.key,
    required this.gameProcessType,
    required this.continents,
    required this.onPressed,
    required this.onChanged,
  });

  final GameProcessType gameProcessType;
  final List<ContinentType> continents;
  final ValueChanged<ContinentType> onPressed;
  final ValueChanged<ContinentType> onChanged;

  @override
  State<ContinentsSlider> createState() => _ContinentsSliderState();
}

class _ContinentsSliderState extends State<ContinentsSlider> {
  late final PageController _controller;
  double _page = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.88)
      ..addListener(_handlePageChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.continents.isNotEmpty) {
        widget.onChanged(widget.continents.first);
      }
    });
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handlePageChanged)
      ..dispose();
    super.dispose();
  }

  void _handlePageChanged() {
    if (!_controller.hasClients) {
      return;
    }

    final page = _controller.page ?? _controller.initialPage.toDouble();
    if (page == _page) {
      return;
    }

    setState(() {
      _page = page;
    });

    final index = page.round().clamp(0, widget.continents.length - 1);
    widget.onChanged(widget.continents[index]);
  }

  void _animateTo(int index) {
    if (!_controller.hasClients) {
      return;
    }

    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 340.h,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.continents.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final continent = widget.continents[index];

              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final distance = (_page - index).abs();
                  final t = (1 - distance).clamp(0.0, 1.0);
                  final scale = 0.72 + (0.28 * Curves.easeOut.transform(t));
                  final opacity = 0.35 + (0.65 * t);
                  final yOffset = 26.h * (1 - t);

                  return Transform.translate(
                    offset: Offset(0, yOffset),
                    child: Transform.scale(
                      scale: scale,
                      child: Opacity(opacity: opacity, child: child),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: ShopItemView(
                    tag: 'continent_$index',
                    builder: (context, isBought) => ScaledGestureDetector(
                      onTap: () => widget.onPressed(continent),
                      child: _ContinentSlide(
                        continent: continent,
                        isBought: isBought,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          left: 6.w,
          child: _ArrowButton(
            icon: Icons.chevron_left_rounded,
            onPressed: () {
              final next = math.max(0, _page.round() - 1);
              _animateTo(next);
            },
          ),
        ),
        Positioned(
          right: 6.w,
          child: _ArrowButton(
            icon: Icons.chevron_right_rounded,
            onPressed: () {
              final next = math.min(
                widget.continents.length - 1,
                _page.round() + 1,
              );
              _animateTo(next);
            },
          ),
        ),
        Positioned(
          bottom: 0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              widget.continents.length,
              (index) {
                final isActive = index == _page.round();
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: isActive ? 14.w : 8.w,
                  height: 8.h,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFF2D6ED8)
                        : ThemePalette.white.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(999.r),
                    border: Border.all(
                      color: const Color(0xFF2E5BA9),
                      width: 1.5.r,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _ContinentSlide extends StatelessWidget {
  const _ContinentSlide({
    required this.continent,
    required this.isBought,
  });

  final ContinentType continent;
  final bool isBought;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 260.h,
          child: Image.asset(
            createContinentImagePath(continent),
            fit: BoxFit.contain,
          ),
        ),
        Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: FText(
              createContinentTitle(continent).toUpperCase(),
              textAlign: TextAlign.center,
              strokeWidth: 10,
              textStyle: TextStyle(
                fontSize: 46.sp,
                height: 1,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ScaledGestureDetector(
      onTap: onPressed,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: ThemePalette.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF6F97E0),
            width: 3.r,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2F66B5).withValues(alpha: 0.28),
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: SizedBox.square(
          dimension: 48.r,
          child: Icon(
            icon,
            size: 34.sp,
            color: const Color(0xFF2D6ED8),
          ),
        ),
      ),
    );
  }
}
