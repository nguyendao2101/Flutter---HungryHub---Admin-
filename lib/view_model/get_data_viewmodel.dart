// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GetDataViewModel extends GetxController {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Biến lưu trữ danh sách cửa hàng, sản phẩm và đơn hàng
  final RxList<Map<String, dynamic>> stores = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchStores(); // Lấy danh sách cửa hàng
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

  // Hàm lấy danh sách sản phẩm
  Future<void> fetchProducts() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('products').get();
      final fetchedProducts = snapshot.docs
          .map((doc) => {
                'id': doc.id, // Lưu productId
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
      products.assignAll(fetchedProducts); // Cập nhật danh sách sản phẩm
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  // Hàm lấy sản phẩm của cửa hàng cụ thể
  Future<void> fetchProductsByStore(String storeId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('storeId', isEqualTo: storeId) // Lọc theo storeId
          .get();
      final fetchedProducts = snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
      products.assignAll(fetchedProducts); // Cập nhật danh sách sản phẩm
    } catch (e) {
      print('Error fetching products by store: $e');
    }
  }

  // Hàm thêm đơn hàng mới cho một cửa hàng

  Future<void> addOrder(String storeId, String userId, List<String> productIds,
      List<int> quantities) async {
    try {
      // Tính tổng giá trị đơn hàng
      int totalAmount = 0;
      for (int i = 0; i < productIds.length; i++) {
        final product = products.firstWhere((p) => p['id'] == productIds[i]);
        totalAmount += (product['price'] as int) * quantities[i];
      }

      // Thêm đơn hàng vào Firestore
      final orderData = {
        'storeId': storeId, // Liên kết với cửa hàng
        'userId': userId,
        'productIds': productIds,
        'quantities': quantities,
        'totalAmount': totalAmount,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('orders').add(orderData);
      print('Đặt hàng thành công!');
    } catch (e) {
      print('Error adding order: $e');
    }
  }

  Future<void> fetchStoresByProduct(String productId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('stores')
          .where('productIds',
              arrayContains: productId) // Tìm store có chứa productId
          .get();
      final fetchedStores = snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
      stores.assignAll(fetchedStores); // Cập nhật danh sách cửa hàng
    } catch (e) {
      print('Error fetching stores by product: $e');
    }
  }

  // Hàm lấy danh sách đơn hàng của một cửa hàng
  Future<void> fetchOrdersByStore(String storeId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('orders')
          .where('storeId', isEqualTo: storeId) // Lọc theo storeId
          .get();
      final fetchedOrders = snapshot.docs
          .map((doc) => {
                'id': doc.id, // Lưu orderId
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
      orders.assignAll(fetchedOrders);
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }
}
