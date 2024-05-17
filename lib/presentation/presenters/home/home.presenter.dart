import 'package:state_manager/state_manager.dart';

abstract interface class IHomePresenter {
  static IHomePresenter get i => Get.find<IHomePresenter>(tag: "single");
}

class HomePresenterImpl extends GetxController implements IHomePresenter {}
