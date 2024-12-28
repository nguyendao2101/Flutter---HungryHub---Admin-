import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry_hub_web/widgets/common/image_extention.dart';
import 'package:hungry_hub_web/widgets/common_widget/button/bassic_button.dart';
import '../../../view_model/get_data_viewmodel.dart';
import '../../../view_model/orders_view_model.dart';
import 'package:intl/intl.dart';  // Thư viện giúp xử lý định dạng ngày tháng

class DayView extends StatefulWidget {
  const DayView({super.key});

  @override
  State<DayView> createState() => _DayViewState();
}

class _DayViewState extends State<DayView> {
  final getDataViewModel = Get.put(GetDataViewModel());
  final ordersViewModel = Get.put(OrdersViewModel());

  List<Map<String, dynamic>> _orderTracking = [];
  Map<String, double> _dailyRevenueToday = {};  // Doanh thu hôm nay
  Map<String, double> _dailyRevenueYesterday = {};  // Doanh thu hôm qua
  Map<String, double> _dailyRevenueLastMonth = {};  // Doanh thu của tháng trước
  bool _isLoadingOrderTracking = true;

  @override
  void initState() {
    super.initState();
    getDataViewModel.fetchRevenueTracking();
    _loadOrderTracking();
  }

  Future<void> _loadOrderTracking() async {
    try {
      setState(() {
        _isLoadingOrderTracking = true;
      });

      // Lấy dữ liệu đơn hàng từ Firestore
      await getDataViewModel.fetchRevenueTracking();

      setState(() {
        _orderTracking = getDataViewModel.getRevenue;
        _filterAndCalculateRevenue(); // Lọc đơn hàng và tính doanh thu
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

  String getYesterdayDate() {
    DateTime yesterday = DateTime.now().subtract(Duration(days: 1));  // Trừ 1 ngày
    return DateFormat('yyyy-MM-dd').format(yesterday);  // Trả về ngày dưới định dạng 'yyyy-MM-dd'
  }

  String getRevenueFromLastMonth() {
    DateTime today = DateTime.now();
    DateTime lastMonth = DateTime(today.year, today.month - 1, today.day);  // Lấy ngày của tháng trước cùng ngày
    return DateFormat('yyyy-MM-dd').format(lastMonth);  // Trả về ngày dưới định dạng 'yyyy-MM-dd'
  }

  void _filterAndCalculateRevenue() {
    _dailyRevenueToday.clear();
    _dailyRevenueYesterday.clear();
    _dailyRevenueLastMonth.clear();

    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());  // Lấy ngày hôm nay
    String yesterdayDate = getYesterdayDate();  // Lấy ngày hôm qua
    String lastMonthDate = getRevenueFromLastMonth();  // Lấy ngày hôm nay nhưng thuộc tháng trước

    var filteredOrdersToday = _orderTracking.where((order) {
      String purchaseDate = order['purchaseDate'].toString();
      DateTime orderDate = DateTime.parse(purchaseDate);
      String purchaseDateOnly = DateFormat('yyyy-MM-dd').format(orderDate);

      return purchaseDateOnly == currentDate && order['storeId'].toString() == ordersViewModel.userId.toString();
    }).toList();

    var filteredOrdersYesterday = _orderTracking.where((order) {
      String purchaseDate = order['purchaseDate'].toString();
      DateTime orderDate = DateTime.parse(purchaseDate);
      String purchaseDateOnly = DateFormat('yyyy-MM-dd').format(orderDate);

      return purchaseDateOnly == yesterdayDate && order['storeId'].toString() == ordersViewModel.userId.toString();
    }).toList();

    var filteredOrdersLastMonth = _orderTracking.where((order) {
      String purchaseDate = order['purchaseDate'].toString();
      DateTime orderDate = DateTime.parse(purchaseDate);
      String purchaseDateOnly = DateFormat('yyyy-MM-dd').format(orderDate);

      return purchaseDateOnly == lastMonthDate && order['storeId'].toString() == ordersViewModel.userId.toString();
    }).toList();

    // Lọc và tính doanh thu cho mỗi ngày
    _calculateRevenue(filteredOrdersToday, _dailyRevenueToday, 'Today');
    _calculateRevenue(filteredOrdersYesterday, _dailyRevenueYesterday, 'Yesterday');
    _calculateRevenue(filteredOrdersLastMonth, _dailyRevenueLastMonth, 'Last Month');
  }

  void _calculateRevenue(List<Map<String, dynamic>> filteredOrders, Map<String, double> revenueData, String period) {
    for (var order in filteredOrders) {
      double total = double.parse(order['total'].toString());
      String storeId = order['storeId'].toString();
      String storeName = order['placeOfPurchase'].toString();

      if (revenueData.containsKey(storeId)) {
        revenueData[storeId] = revenueData[storeId]! + total;
      } else {
        revenueData[storeId] = total;
      }
    }

    print("Revenue for $period: $revenueData");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoadingOrderTracking
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadOrderTracking,
        child: _dailyRevenueToday.isEmpty && _dailyRevenueYesterday.isEmpty && _dailyRevenueLastMonth.isEmpty
            ? const Center(child: Text("Không có doanh thu trong ngày"))
            : SingleChildScrollView(
          child: Row(
            children: [
              Expanded(flex: 1,child: Container()),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    const SizedBox(height: 40,),
                    _buildRevenueCard('Today', _dailyRevenueToday),
                    _buildRevenueCard('Yesterday', _dailyRevenueYesterday),
                    _buildRevenueCard('Last Month', _dailyRevenueLastMonth),
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

  Widget _buildRevenueCard(String period, Map<String, double> revenueData) {
    return Column(
      children: [
        const SizedBox(height: 12,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('$period Revenue:', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12,),
        for (var storeId in revenueData.keys) ...[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 3, blurRadius: 7)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Shop ID: $storeId', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const Divider(),
                Text('Total Revenue: ${revenueData[storeId]} VND', style: const TextStyle(fontSize: 16, color: Color(0xffA02334), fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

