import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainNavShopViewModel extends GetxController{
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final _userData = {}.obs;
  String userId = '';
  RxMap get userData => _userData;
  var isDrawerOpen = false.obs; // Khởi tạo biến quan sát
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void onInit() {
    super.onInit();
    _initializeUserId();
  }

  void _initializeUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      await _getUserData();
    }
  }

  Future<void> _getUserData() async {
    DatabaseReference userRef = _database.child('users/$userId');
    DataSnapshot snapshot = await userRef.get();

    if (snapshot.exists) {
      _userData.value = Map<String, dynamic>.from(snapshot.value as Map);
    } else {
      _userData.value = {};
    }
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
    isDrawerOpen.value = true;
  }

  void closeDrawer() {
    scaffoldKey.currentState?.closeDrawer();
    isDrawerOpen.value = false;
  }
}