import 'package:flutter/material.dart';
import 'package:food_delivery/data/repository/cart_repo.dart';
import 'package:food_delivery/models/cart_model.dart';
import 'package:food_delivery/models/products_model.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CartController extends GetxController {
  final CartRepo cartRepo;
  CartController({required this.cartRepo});
  Map<int, CartModel> _items = {};
  Map<int, CartModel> get items => _items;

  void addItem(ProductModel product, int quantity) {
    if(_items.containsKey(product.id!)){
      //update
      _items.update(product.id!, (value) {
        return CartModel(id: product.id,
          name: value.name,
          price: value.price,
          img: value.img,
          quantity: value.quantity!+quantity,
          isExsit: true,
          time: DateTime.now().toString(),);
      });
    } else {
      // print("length of th item is " + _items.length.toString());
      //edit
      _items.putIfAbsent(product.id!, () {
        // print("adding item to the cart id " +
        //     product.id!.toString() +
        //     " quantity " +
        //     quantity.toString());
        // _itemsforEach(key, value) {
        //   print("quantity is " + value.quantity.toString());
        // }

        ;
        return CartModel(
          id: product.id,
          name: product.name,
          price: product.price,
          img: product.img,
          quantity: quantity,
          isExsit: true,
          time: DateTime.now().toString(),
        );
      });
    }

  }
}
