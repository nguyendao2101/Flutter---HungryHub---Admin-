import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class OrdersViewModel extends GetxController {
  //firebase realtime
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  //firebase firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<Map<String, dynamic>> coupons = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> ordersList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> addressList = <Map<String, dynamic>>[].obs;
  final RxList<int> selectedItems = <int>[].obs; // Danh sách index của các sản phẩm được chọn
  final RxList<Map<String, dynamic>> stores = <Map<String, dynamic>>[].obs;


  final RxString userId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeUserId();
    _listenToOrders();
    fetchCoupons();
    fetchStores();
    fetchLocationsFromFirebase();
  }

  // Hàm lấy danh sách cửa hàng
  Future<void> fetchStores() async {
    try {
      final QuerySnapshot snapshot =
      await _firestore.collection('stores').get();
      final fetchedStores = snapshot.docs
          .map((doc) => {
        'id': doc.id, // Lưu storeId
        ...doc.data() as Map<String, dynamic>,
      })
          .toList();

      // In ra các cửa hàng đã lấy được
      print('Stores fetched:');
      fetchedStores.forEach((store) {
        print('Store ID: ${store['id']}, Store Data: $store');
      });

      // Gán danh sách cửa hàng vào biến stores
      stores.assignAll(fetchedStores);
    } catch (e) {
      print('Error fetching stores: $e');
    }
  }


  // hàm lấy danh sách coupon
  Future<void> fetchCoupons() async {
    try {
      print('Fetching coupons...');
      final QuerySnapshot snapshot = await _firestore.collection('coupon').get();
      print('Raw snapshot data: ${snapshot.docs}');

      final fetchedCoupons = snapshot.docs.map((doc) {
        print('Document ID: ${doc.id}, Data: ${doc.data()}');
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();

      coupons.assignAll(fetchedCoupons); // Cập nhật danh sách coupon
      print('Fetched coupons: $fetchedCoupons');
      print('Fetched coupons2: $coupons');
    } catch (e) {
      print('Error fetching coupons: ${e.toString()}');
    }
  }


  void _initializeUserId() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      userId.value = currentUser.uid;
    }
  }

  void _listenToOrders() {
    if (userId.isEmpty) return;

    _databaseReference.child('users/${userId.value}/ShoppingCart').onValue.listen((event) {
      if (event.snapshot.exists && event.snapshot.value is List) {
        final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
          (event.snapshot.value as List).map(
                (item) => Map<String, dynamic>.from(item as Map),
          ),
        );
        ordersList.value = data;
      } else {
        ordersList.clear();
      }
    });
  }
  Future<Map<String, String>> fetchLocationsFromFirebase() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("No user is signed in.");
      }

      String userId = currentUser.uid;
      DataSnapshot snapshot = await _databaseReference.child('users/$userId/AddAdress').get();

      if (snapshot.exists && snapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        return data.map((key, value) => MapEntry(key.toString(), value.toString()));
      } else {
        debugPrint("No valid data found for locations.");
      }
    } catch (e) {
      debugPrint("Error fetching locations: $e");
    }
    return {}; // Trả về Map rỗng khi không có dữ liệu
  }


  void selectItem(int index) {
    selectedItems.add(index); // Thêm sản phẩm vào danh sách đã chọn
  }

  void deselectItem(int index) {
    selectedItems.remove(index); // Loại sản phẩm khỏi danh sách đã chọn
  }

  void toggleItemSelection(int index) {
    if (selectedItems.contains(index)) {
      deselectItem(index);
    } else {
      selectItem(index);
    }
  }

  void increaseQuantity(int index) {
    ordersList[index]['Quantity'] = (ordersList[index]['Quantity'] ?? 1) + 1;
    ordersList.refresh();
  }

  void decreaseQuantity(int index) {
    if (ordersList[index]['Quantity'] > 1) {
      ordersList[index]['Quantity'] -= 1;
      ordersList.refresh();
    }
  }

  List<Map<String, dynamic>> checkoutSelectedItems() {
    // Lấy danh sách sản phẩm được chọn
    final selectedProducts = selectedItems.map((index) {
      final product = Map<String, dynamic>.from(ordersList[index]); // Tạo bản sao của sản phẩm
      product['Quantity'] = ordersList[index]['Quantity'] ?? 1; // Thêm trường Quantity
      return product; // Trả về sản phẩm đã được thêm trường
    }).toList();

    // Trả về danh sách các sản phẩm đã được chọn
    return selectedProducts;
  }

  double calculateTotal(List<Map<String, dynamic>> product) {
    double total = 0.0;
    for (var item in product) {
      total += item['Price']*item['Quantity']; // Cộng dồn giá của mỗi sản phẩm
    }
    return total;
  }

}
