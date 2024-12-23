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

  final RxMap _browseShopData = {}.obs;
  RxMap get browseShopData => _browseShopData;

  // Biến lưu thông tin người dùng từ cả hai đường dẫn 'users/$_userId' và 'browseShop/$_userId'
  Map<String, dynamic> currentUserInfo = {};

  @override
  void onInit() {
    super.onInit();
    _initializeUserId();
  }

  // Lấy User ID từ FirebaseAuth
  void _initializeUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
      await _getUserData();
      await _getUserIdFromBrowseShop();
    }
  }

  // Lấy thông tin người dùng từ 'browseShop/$_userId' và sau đó kiểm tra với 'users/$_userId'
  Future<void> _getUserData() async {
    DatabaseReference userRef = _database.child('users/$_userId');
    DatabaseReference browseShopRef = _database.child('browseShop/$_userId');

    // Lấy dữ liệu từ 'browseShop/$_userId'
    DataSnapshot browseShopSnapshot = await browseShopRef.get();
    if (browseShopSnapshot.exists) {
      _browseShopData.value = Map<String, dynamic>.from(browseShopSnapshot.value as Map);
      currentUserInfo = Map<String, dynamic>.from(browseShopSnapshot.value as Map);
    } else {
      _browseShopData.value = {};
      print("BrowseShop data not found.");
    }

    // Kiểm tra và lấy dữ liệu từ 'users/$_userId'
    DataSnapshot userSnapshot = await userRef.get();
    if (userSnapshot.exists) {
      Map<String, dynamic> userInfo = Map<String, dynamic>.from(userSnapshot.value as Map);
      // Cập nhật dữ liệu của người dùng nếu dữ liệu từ 'users' tồn tại
      currentUserInfo.addAll(userInfo);
    }

    _userData.value = currentUserInfo; // Lưu thông tin vào _userData để cập nhật UI
    update();
  }

  // Cập nhật thông tin người dùng ở cả hai đường dẫn: 'users/$_userId' và 'browseShop/$_userId'
  Future<void> updateUserData(Map<String, dynamic> newUserData) async {
    try {
      DatabaseReference userRef = _database.child('users/$_userId');
      DatabaseReference browseShopRef = _database.child('browseShop/$_userId');

      // Cập nhật thông tin người dùng
      await userRef.update(newUserData);
      await browseShopRef.update(newUserData);

      // Cập nhật lại dữ liệu local sau khi thay đổi thành công
      currentUserInfo.addAll(newUserData);
      _userData.value = currentUserInfo;
      _browseShopData.value = currentUserInfo;

      update();  // Cập nhật UI

      Get.snackbar(
        "Success",
        "User information updated successfully in both sections!",
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update user information: $e",
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> _getUserIdFromBrowseShop() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;

      // Fetch user data from 'browseShop/$_userId'
      final browseShopSnapshot = await _database.child('browseShop/$_userId').get();
      if (browseShopSnapshot.exists) {
        _browseShopData.value = Map<String, dynamic>.from(browseShopSnapshot.value as Map);

        // Now get the corresponding user data from 'users/$_userId'
        final userSnapshot = await _database.child('users/$_userId').get();
        if (userSnapshot.exists) {
          _userData.value = Map<String, dynamic>.from(userSnapshot.value as Map);
        } else {
          _userData.value = {}; // If no data, initialize with empty map
        }
      } else {
        print("No data found in browseShop for $_userId");
        _browseShopData.value = {};
      }
    }
  }

  // Giao diện để sửa thông tin người dùng
  Widget editUserInfoUI() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: currentUserInfo['name'] ?? '',
            decoration: InputDecoration(labelText: 'Name'),
            onSaved: (value) {
              currentUserInfo['name'] = value;
            },
          ),
          TextFormField(
            initialValue: currentUserInfo['email'] ?? '',
            decoration: InputDecoration(labelText: 'Email'),
            onSaved: (value) {
              currentUserInfo['email'] = value;
            },
          ),
          TextFormField(
            initialValue: currentUserInfo['address'] ?? '',
            decoration: InputDecoration(labelText: 'Address'),
            onSaved: (value) {
              currentUserInfo['address'] = value;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () async {
                  formKey.currentState?.save();
                  await updateUserData(currentUserInfo); // Gọi hàm cập nhật thông tin
                },
                child: Text('Update Info'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
