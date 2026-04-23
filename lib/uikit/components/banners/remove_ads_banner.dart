import 'dart:io';

import 'package:flags/features/app/features/monetization/presentation/bloc/monetization_cubit.dart';
import 'package:flags/features/app/features/monetization/presentation/bloc/monetization_state.dart';
import 'package:flags/uikit/assets/components/remove_ads.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/components/progress_indicator/linear_progress_indicator.dart';
import 'package:flags/uikit/layout_components/gap/gap.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RemoveAdsBanner extends StatelessWidget {
  const RemoveAdsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF5D72E7);
    const borderColor = Color(0xff202377);
    const subtitleColor = Color(0xFFCFE5FF);

    final cubit = context.watch<MonetizationCubit>();
    if (cubit.state.isPremium) {
      return const SizedBox.shrink();
    }

    Future<void> showPurchaseDialog() async {
      final cubit = context.read<MonetizationCubit>();
      cubit.resetPurchaseDialogState();
      final state = cubit.state;

      if (state.isPremium) {
        return;
      }

      await showDialog(
        context: context,
        builder: (context) => BlocBuilder<MonetizationCubit, MonetizationState>(
          bloc: cubit,
          builder: (context, state) {
            return AlertDialog(
              backgroundColor: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
                side: const BorderSide(color: borderColor, width: 4),
              ),
              title: Center(
                child: FText(
                  "REMOVE ADS",
                  textColor: ThemePalette.yellow,
                  textStyle: TextStyle(fontSize: 32.sp),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 100.h,
                    child: RemoveAdsImage(),
                  ),
                  Gap.v16,
                  FText(
                    "Get the full experience without any interruptions!",
                    textAlign: TextAlign.center,
                    textColor: subtitleColor,
                    textStyle: TextStyle(fontSize: 16.sp),
                  ),
                  if (state.statusMessage != null) ...[
                    Gap.v8,
                    FText(
                      state.statusMessage!,
                      textColor: Colors.redAccent,
                      textStyle: TextStyle(fontSize: 12.sp),
                    ),
                  ],
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                if (state.isPurchasePending)
                  const FLinearProgressIndicator()
                else
                  Column(
                    children: [
                      FYellowButton(
                        onPressed: () => cubit.buyNoAdsSubscription(context),
                        child: FText("BUY ${state.productPriceLabel}"),
                      ),
                      if (Platform.isIOS) ...[
                        Gap.v8,
                        TextButton(
                          onPressed: cubit.restorePurchases,
                          child: FText(
                            "Restore Purchase",
                            textStyle: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ],
                  ),
              ],
            );
          },
        ),
      );
    }

    return FButton(
      color: backgroundColor,
      onPressed: showPurchaseDialog,
      child: SizedBox(
        height: 54.h,
        child: Row(
          children: [
            SizedBox(
              width: 62.w,
              child: Center(
                child: SizedBox(
                  width: 54.w,
                  height: 54.h,
                  child: RemoveAdsImage(),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FText(
                    'REMOVE ADS',
                    strokeWidth: 4,
                    textColor: ThemePalette.yellow,
                    textStyle: TextStyle(
                      fontSize: 20.sp,
                      height: 1,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  FText(
                    'Enjoy Flags Up ad-free!',
                    strokeWidth: 3,
                    textColor: subtitleColor,
                    textStyle: TextStyle(
                      fontSize: 11.sp,
                      height: 1,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
