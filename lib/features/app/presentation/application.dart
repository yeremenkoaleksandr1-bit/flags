import 'package:bloc_utils/bloc_utils.dart';
import 'package:flags/features/app/data/shop_items.dart';
import 'package:flags/features/app/features/shop/domain/shop.item.dart';
import 'package:flags/features/app/features/shop/presentation/bloc/shop_cubit.dart';
import 'package:flags/features/app/features/vibration/presentation/bloc/vibration_cubit.dart';
import 'package:flags/features/app/presentation/bloc/app_cubit.dart';
import 'package:flags/features/app/presentation/builder/app_state_builder.dart';
import 'package:flags/features/app/presentation/widgets/flags_widget_app.dart';
import 'package:flags/main.dart';
import 'package:flags/presentation/navigator/router.dart';
import 'package:flags/resources/resources.dart';
import 'package:flags/services/game_state/game_state_cubit.dart';
import 'package:flags/services/layers/money_layer/money_layer.dart';
import 'package:flags/ui/builders/main_router_builder.dart';
import 'package:flags/ui/debug_paint.dart';
import 'package:flags/uikit/drag_and_drop/provider.dart';
import 'package:flags/uikit/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  final AppRouter router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<IAppCubit>(
          create: (context) => AppCubitImpl(
            context: context,
          ),
        ),
        BlocProvider(
          create: (_) => GameStateCubit(),
        ),
      ],
      child: BlocStateBuilderThemeProvider(
        child: FlagsWidgetsApp(
          title: "FlagsUp",
          theme: AppTheme.themeData,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, _) {
            return DragAndDropProvider(
              builder: (BuildContext context) {
                return DebugPaintProvider(
                  builder: (BuildContext context) {
                    return EasyLoading.init()(
                      context,
                      BuildAppState(
                        builder: (context, state) {
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider<IShopCubit>(
                                create: (context) => ShopCubit(
                                  gamePreferences:
                                      context.read<IAppCubit>().gameState,
                                  buyableItems: shopItemsData,
                                ),
                              ),
                              BlocProvider<IVibrationCubit>(
                                create: (BuildContext context) {
                                  return VibrationCubit(
                                    sharedPreferences,
                                  );
                                },
                              ),
                            ],
                            child: Stack(
                              children: [
                                AppRouterBuilder(
                                  router: router,
                                ),
                               // const UiMoneyLayer(),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
