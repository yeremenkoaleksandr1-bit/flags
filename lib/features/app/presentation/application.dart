import 'package:bloc_utils/bloc_utils.dart';
import 'package:flags/app/app_bootstrap.dart';
import 'package:flags/app/app_scope.dart';
import 'package:flags/domain/preferences/game_preferences.dart';
import 'package:flags/features/app/data/shop_items.dart';
import 'package:flags/features/app/features/audio/presentation/bloc/audio_cubit.dart';
import 'package:flags/features/app/features/shop/domain/services/shop.service.dart';
import 'package:flags/features/app/features/shop/presentation/bloc/shop_cubit.dart';
import 'package:flags/features/app/features/vibration/presentation/bloc/vibration_cubit.dart';
import 'package:flags/features/app/presentation/bloc/app_cubit.dart';
import 'package:flags/features/app/presentation/builder/app_state_builder.dart';
import 'package:flags/features/app/presentation/widgets/flags_widget_app.dart';
import 'package:flags/navigator/router.dart';
import 'package:flags/services/game_state/game_state_cubit.dart';
import 'package:flags/services/layers/money_layer/money_layer.dart';
import 'package:flags/ui/builders/main_router_builder.dart';
import 'package:flags/ui/clouds/clouds_painter.dart';
import 'package:flags/uikit/components/background/background.dart';
import 'package:flags/uikit/drag_and_drop/provider.dart';
import 'package:flags/uikit/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Application extends StatefulWidget {
  const Application({super.key, required this.bootstrap});

  final AppBootstrap bootstrap;

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  final AppRouter router = AppRouter();

  @override
  Widget build(BuildContext context) {
    final sharedPreferences = widget.bootstrap.sharedPreferences;

    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return AppScope(
          bootstrap: widget.bootstrap,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<IAppCubit>(
                create: (context) => AppCubitImpl(
                  context: context,
                  sharedPreferences: sharedPreferences,
                ),
              ),
              BlocProvider(create: (_) => GameStateCubit()),
              BlocProvider(
                create: (_) => GamePreferencesCubit(sharedPreferences),
              ),
              BlocProvider<IShopCubit>(
                create: (context) => ShopCubit(
                  gamePreferences: context.read<GamePreferencesCubit>(),
                  buyableItems: shopItemsData,
                  service: ShopServiceImpl(sharedPreferences),
                ),
              ),
              BlocProvider<IVibrationCubit>(
                create: (_) => VibrationCubit(sharedPreferences),
              ),
              BlocProvider<IAudioCubit>(
                create: (_) => AudioCubit(sharedPreferences),
              ),
            ],
            child: BlocStateBuilderThemeProvider(
              child: FlagsWidgetsApp(
                title: "Flags Up",
                theme: AppTheme.themeData,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                builder: (context, _) {
                  return MediaQuery(
                    data: MediaQuery.of(
                      context,
                    ).copyWith(textScaler: TextScaler.noScaling),
                    child: DragAndDropProvider(
                      builder: (BuildContext context) {
                        return EasyLoading.init()(
                          context,
                          BuildAppState(
                            builder: (context, state) {
                              return Stack(
                                children: [
                                  const Positioned.fill(
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Color(0xff75C3F7),
                                      ),
                                    ),
                                  ),
                                  const Positioned.fill(child: CloudsPainter()),
                                  const Positioned.fill(child: Background()),
                                  AppRouterBuilder(router: router),
                                  const UiMoneyLayer(),
                                ],
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
