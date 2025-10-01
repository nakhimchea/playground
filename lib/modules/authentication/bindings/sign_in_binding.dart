import 'package:get/get.dart';
import 'package:playground/modules/authentication/controllers/sign_in_controller.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SingInController>(() => SingInController());
  }
}
