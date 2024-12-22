// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeViewModel extends GetxController {
  late TextEditingController searchController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final List<Map<String, dynamic>> shoppingCart = [];
  final RxList<Map<String, dynamic>> favoriteProducts = <Map<String, dynamic>>[].obs;
  final formKey = GlobalKey<FormState>();
  final _userData = {}.obs;
  String _userId = '';
  bool isListening = false;
  RxMap get userData => _userData;


  @override
  void onInit() {
    super.onInit();
    _initializeUserId();
  }

  void _initializeUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
      await _getUserData();
    }
  }

  void toggleFavorite(Map<String, dynamic> product) {
    if (isFavorite(product)) {
      favoriteProducts.remove(product);
    } else {
      favoriteProducts.add(product);
      addToFavoriteCart(product);
    }
  }

  bool isFavorite(Map<String, dynamic> product) {
    return favoriteProducts.contains(product);
  }

  Future<void> addToFavoriteCart(Map<String, dynamic> product) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception("No user is signed in.");
      }

      String userId = currentUser.uid;

      // Lấy danh sách ShoppingCart hiện tại từ Firebase
      final snapshot = await _database.child('users/$userId/FavoriteCart').get();
      List<dynamic> currentCart = [];

      if (snapshot.exists && snapshot.value is List) {
        currentCart = List<dynamic>.from(snapshot.value as List);
      }

      // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
      bool isProductInCart = currentCart.any((item) => item['id'] == product['id']); // Kiểm tra dựa trên 'id' của sản phẩm

      if (isProductInCart) {
        Get.snackbar(
          "Info",
          "This product is already in your favorite cart.",
          snackPosition: SnackPosition.TOP,
        );
      } else {
        // Thêm sản phẩm mới vào danh sách
        currentCart.add(product);

        // Ghi danh sách cập nhật lên Firebase
        await _database.child('users/$userId/FavoriteCart').set(currentCart);

        // Cập nhật lại shoppingCart và thông báo thành công
        shoppingCart.clear();
        shoppingCart.addAll(currentCart.cast<Map<String, dynamic>>()); // Cập nhật shoppingCart bằng cách cast lại dữ liệu
        update(); // Cập nhật UI

        Get.snackbar(
          "Success",
          "Product added to FavoriteCart!",
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Success",
        "Product added to FavoriteCart!",
        snackPosition: SnackPosition.TOP,
      );
    }
  }


  Future<void> addToShoppingCart(Map<String, dynamic> product) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception("No user is signed in.");
      }

      String userId = currentUser.uid;

      // Lấy danh sách ShoppingCart hiện tại từ Firebase
      final snapshot = await _database.child('users/$userId/ShoppingCart').get();
      List<dynamic> currentCart = [];

      if (snapshot.exists && snapshot.value is List) {
        currentCart = List<dynamic>.from(snapshot.value as List);
      }

      // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
      bool isProductInCart = currentCart.any((item) => item['id'] == product['id']); // Kiểm tra dựa trên 'id' của sản phẩm

      if (isProductInCart) {
        Get.snackbar(
          "Info",
          "This product is already in your shopping cart.",
          snackPosition: SnackPosition.TOP,
        );
      } else {
        // Thêm sản phẩm mới vào danh sách
        currentCart.add(product);

        // Ghi danh sách cập nhật lên Firebase
        await _database.child('users/$userId/ShoppingCart').set(currentCart);

        // Cập nhật lại shoppingCart và thông báo thành công
        shoppingCart.clear();
        shoppingCart.addAll(currentCart.cast<Map<String, dynamic>>()); // Cập nhật shoppingCart bằng cách cast lại dữ liệu
        update(); // Cập nhật UI

        Get.snackbar(
          "Success",
          "Product added to ShoppingCart!",
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Success",
        "Product added to ShoppingCart!",
        snackPosition: SnackPosition.TOP,
      );
    }
  }



  Future<void> _getUserData() async {
    DatabaseReference userRef = _database.child('users/$_userId');
    DataSnapshot snapshot = await userRef.get();

    if (snapshot.exists) {
      _userData.value = Map<String, dynamic>.from(snapshot.value as Map);
    } else {
      _userData.value = {};
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
