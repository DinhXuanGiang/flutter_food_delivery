import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../controllers/cart_controller.dart';
import '../../models/cart_model.dart';
import '../../routes/route_helper.dart';
import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import 'package:get/get.dart';

import '../../widgets/small_text.dart';

class CartHistory extends StatelessWidget {
  const CartHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var getCartHistoryList = Get.find<CartController>()
        .getCartHistoryList().reversed.toList();

    Map <String, int> cartItemsPerOrder = Map();

    for(int i = 0; i < getCartHistoryList.length; i++){
      if(cartItemsPerOrder.containsKey(getCartHistoryList[i].time)){
        cartItemsPerOrder.update(getCartHistoryList[i].time!, (value)=>++value);
      }
      else {
        cartItemsPerOrder.putIfAbsent(getCartHistoryList[i].time!, ()=>1);
      }
    }
//   print(cartItemsPerOrder);

    //value of the map
    List <int> cartItemsPerOrderToList(){
      return cartItemsPerOrder.entries.map((e)=>e.value).toList();
    }
    //key of the map
    List <String> cartOrderTimeToList(){
      return cartItemsPerOrder.entries.map((e)=>e.key).toList();
    }

    List<int> itemsPerOrder = cartItemsPerOrderToList(); // 2, 2, 3, 4

    var listCounter = 0;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: Dimensions.height10*10,
            color: AppColors.mainColor,
            width: double.maxFinite,
            padding: EdgeInsets.only(top: Dimensions.height45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BigText(text: "Your Cart History", color: Colors.white),
                AppIcon(
                    icon: Icons.shopping_cart_outlined,
                    iconColor: AppColors.mainColor,
                    backgroundColor: AppColors.yellowColor),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: Dimensions.height20, left: Dimensions.width20, right: Dimensions.width20),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView(
                  children: [
                    for(int i = 0; i < itemsPerOrder.length; i++)
                      Container(
                        height: Dimensions.height30*4,
                        margin: EdgeInsets.only(bottom: Dimensions.height20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //immediately invoked function
                            ((){
                              DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(getCartHistoryList[listCounter].time!);
                              var inputDate = DateTime.parse(parseDate.toString());
                              var outputFormat = DateFormat("MM/dd/yyyy hh:mm a");
                              var outputDate = outputFormat.format(inputDate);
                              return BigText(text: outputDate);
                            }()),
                            SizedBox(height: Dimensions.height10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Wrap(
                                  direction: Axis.horizontal,
                                  children: List.generate(itemsPerOrder[i], (index){
                                    if(listCounter<getCartHistoryList.length){
                                      listCounter++;
                                    }
                                    return index <=2?Container(
                                        height: Dimensions.height20*4,
                                        width: Dimensions.width20*4,
                                        margin: EdgeInsets.only(right: Dimensions.width10/5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(Dimensions.radius15/2),
                                          image: DecorationImage(
                                            fit:BoxFit.cover,
                                            image: NetworkImage(
                                              AppConstants.BASE_URL + AppConstants.UPLOAD_URL + getCartHistoryList[listCounter-1].img!
                                            ),
                                          ),
                                        ),
                                    ):Container();
                                  }),
                                ),
                                Container(
                                  // color: Colors.red,
                                  height: Dimensions.height20*4,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SmallText(text: "Total", color: AppColors.titleColor),
                                      BigText(text: itemsPerOrder[i].toString() + " Items", color: AppColors.titleColor),
                                      GestureDetector(
                                        onTap: () {
                                          var orderTime = cartOrderTimeToList();
                                          // print("Order time: " + orderTime[i].toString());
                                          Map<int, CartModel> moreOrder = {};
                                          for(int j = 0; j < getCartHistoryList.length; j++) {
                                            if(getCartHistoryList[j].time == orderTime[i]){
                                              // print("My order time is: " + orderTime[i]);
                                              moreOrder.putIfAbsent(getCartHistoryList[j].id!, () =>
                                                CartModel.fromJson(jsonDecode(jsonEncode(getCartHistoryList[j])))
                                              );
                                              // print("The cart or product id is " + getCartHistoryList[j].id.toString());
                                              // print("Product info is: " + jsonEncode(getCartHistoryList[j]));
                                            }
                                          }
                                          Get.find<CartController>().setItems = moreOrder;
                                          Get.find<CartController>().addToCartList();
                                          Get.toNamed(RouteHelper.getCartPage());
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: Dimensions.width10/2,
                                            vertical: Dimensions.height10/2,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(Dimensions.radius15/3),
                                            border: Border.all(width: 1, color: AppColors.mainColor),
                                          ),
                                          child: SmallText(text: "one more", color: AppColors.mainColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
