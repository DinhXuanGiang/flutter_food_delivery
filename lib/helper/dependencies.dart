import 'package:food_delivery/controllers/popular_product_controller.dart';
import 'package:food_delivery/data/api/api_client.dart';
import 'package:food_delivery/data/repository/popular_product_repo.dart';
import 'package:get/get.dart';

Future<void> init() async {
  //api client
  Get.lazyPut(() => ApiClient(appBaseUrl: "http://mvs.bslmeiyu.com"));

  //repo
  Get.lazyPut(() => PopularProductRepo(apiClient: Get.find()));

  //UIViewControllerBasedStatusBarAppearance

  Get.lazyPut(() => PopularProductController(popularProductRepo: Get.find()));
}