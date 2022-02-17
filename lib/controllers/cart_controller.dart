import 'package:food_delivery/data/repository/cart_repo.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CartController extends GetxController {
  final CartRepo cartRepo;
  CartController({required this.cartRepo});
}