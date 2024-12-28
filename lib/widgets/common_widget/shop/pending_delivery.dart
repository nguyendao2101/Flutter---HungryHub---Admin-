import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry_hub_web/widgets/common/image_extention.dart';

import '../../../view_model/get_data_viewmodel.dart';
import '../../../view_model/orders_view_model.dart';
import '../evaluate/evaluate.dart';

class PendingDelivery extends StatefulWidget {
  const PendingDelivery({super.key});

  @override
  State<PendingDelivery> createState() => _PendingDeliveryState();
}

class _PendingDeliveryState extends State<PendingDelivery> {
  final getDataViewModel = Get.put(GetDataViewModel());
  final ordersViewModel = Get.put(OrdersViewModel());

  List<Map<String, dynamic>> _orderTracking = [];
  bool _isLoadingOrderTracking = true;

  @override
  void initState() {
    super.initState();
    getDataViewModel.fetchOrderTracking();
    getDataViewModel.orderTracking;
    _loadOrderTracking();
  }

  Future<void> _loadOrderTracking() async {
    try {
      setState(() {
        _isLoadingOrderTracking = true;
      });
      // Fetch data từ server
      await getDataViewModel.fetchProducts();
      // Kiểm tra log dữ liệu mới
      print("Fetched orderTracking: ${getDataViewModel.orderTracking}");

      setState(() {
        _orderTracking = getDataViewModel.orderTracking;
      });
    } catch (e) {
      print("Error loading data: $e");
      Get.snackbar(
        "Error",
        "Failed to load data. Please try again later.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() {
        _isLoadingOrderTracking = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoadingOrderTracking
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadOrderTracking,
        child: _orderTracking.isEmpty
            ? const Center(child: Text("Your Confirm Cart is empty."))
            : SingleChildScrollView(
          child: Row(
            children: [
              Expanded(flex: 1,child: Container()),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    for (var order in _orderTracking) ...[
                      if ((order['storeId'].toString() ==
                          ordersViewModel.userId.toString()) &&
                          (order['status'].toString() == 'Waiting Delivery'))
                        Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 12.0,
                          ),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 7,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order ID: ${order['orderId']}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Color(0xff1C1B1F),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              if (order['listProducts'] is List)
                                for (var product
                                in order['listProducts'])
                                  Card(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 12,
                                    ),
                                    child: ListTile(
                                      leading: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(8),
                                        child: Image.network(
                                          product['imageFace'] ?? '',
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      title: Text(
                                        product['nameProduct'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff1C1B1F),
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      subtitle: Text(
                                        "Quantity: ${product['quantities']}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff1C1B1F),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                  ),
                              const SizedBox(height: 4),
                              const Divider(),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Address: ${order['deliveryAddress']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff1C1B1F),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      'Payment Method: ${order['paymentMethod']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff1C1B1F),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      'Place of Purchase: ${order['placeOfPurchase']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff1C1B1F),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total: ${order['total']} VND',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Color(0xffA02334),
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                await getDataViewModel.updateOrderStatus(order['orderId'], 'Confirm');
                                                // getDataViewModel.refreshOrderTracking(); // Làm mới danh sách
                                                setState(() {
                                                  // Tìm và cập nhật trạng thái trong danh sách hiện tại
                                                  final index = _orderTracking.indexWhere((o) => o['orderId'] == order['orderId']);
                                                  if (index != -1) {
                                                    _orderTracking[index]['status'] = 'Confirm';
                                                  }
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: const Color(0xffFBFBFB),
                                                backgroundColor: const Color(0xffFF4545), // Màu chữ khi button được nhấn
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(4), // Bo góc với bán kính 12
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Text('Back To Confirm'),
                                                  const SizedBox(width: 12,),
                                                  Image.asset(ImageAsset.confirmation, height: 20,)
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 16,),
                                            ElevatedButton(
                                              onPressed: () async {
                                                await getDataViewModel.updateOrderStatus(order['orderId'], 'Delivered');
                                                // getDataViewModel.refreshOrderTracking(); // Làm mới danh sách
                                                setState(() {
                                                  // Tìm và cập nhật trạng thái trong danh sách hiện tại
                                                  final index = _orderTracking.indexWhere((o) => o['orderId'] == order['orderId']);
                                                  if (index != -1) {
                                                    _orderTracking[index]['status'] = 'Delivered';
                                                  }
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: const Color(0xffFBFBFB),
                                                backgroundColor: const Color(0xff5CB338), // Màu chữ khi button được nhấn
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(4), // Bo góc với bán kính 12
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Text('To Delivered'),
                                                  const SizedBox(width: 12,),
                                                  Image.asset(ImageAsset.delivered, height: 24,)
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                    const SizedBox(height: 50,),
                  ],
                ),
              ),
              Expanded(flex: 1,child: Container()),

            ],
          ),
        ),
      ),
    );
  }
}
