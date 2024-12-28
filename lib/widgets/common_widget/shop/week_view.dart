import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry_hub_web/widgets/common/image_extention.dart';
import 'package:hungry_hub_web/widgets/common_widget/button/bassic_button.dart';
import '../../../view_model/get_data_viewmodel.dart';
import '../../../view_model/orders_view_model.dart';
import 'package:intl/intl.dart'; // Thư viện giúp xử lý định dạng ngày tháng

class WeekView extends StatefulWidget {
  const WeekView({super.key});

  @override
  State<WeekView> createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView> {
  final getDataViewModel = Get.put(GetDataViewModel());
  final ordersViewModel = Get.put(OrdersViewModel());

  List<Map<String, dynamic>> _orderTracking = [];
  Map<String, double> _weeklyRevenueCurrent = {}; // Doanh thu tuần hiện tại
  Map<String, double> _weeklyRevenueLast = {}; // Doanh thu tuần trước
  Map<String, double> _weeklyRevenueMonthLast = {}; // Doanh thu tuần tương ứng tháng trước
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

  DateTime getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1)); // Lấy ngày đầu tuần (thứ 2)
  }

  String getFormattedDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date); // Định dạng ngày thành chuỗi
  }

  void _filterAndCalculateRevenue() {
    _weeklyRevenueCurrent.clear();
    _weeklyRevenueLast.clear();
    _weeklyRevenueMonthLast.clear();

    DateTime now = DateTime.now();
    DateTime startOfThisWeek = getStartOfWeek(now);
    DateTime startOfLastWeek = startOfThisWeek.subtract(const Duration(days: 7));
    DateTime startOfSameWeekLastMonth = DateTime(now.year, now.month - 1, now.day);

    var filteredOrdersCurrentWeek = _orderTracking.where((order) {
      DateTime orderDate = DateTime.parse(order['purchaseDate'].toString());
      return orderDate.isAfter(startOfThisWeek) &&
          orderDate.isBefore(startOfThisWeek.add(const Duration(days: 7))) &&
          order['storeId'].toString() == ordersViewModel.userId.toString();
    }).toList();

    var filteredOrdersLastWeek = _orderTracking.where((order) {
      DateTime orderDate = DateTime.parse(order['purchaseDate'].toString());
      return orderDate.isAfter(startOfLastWeek) &&
          orderDate.isBefore(startOfLastWeek.add(const Duration(days: 7))) &&
          order['storeId'].toString() == ordersViewModel.userId.toString();
    }).toList();

    var filteredOrdersSameWeekLastMonth = _orderTracking.where((order) {
      DateTime orderDate = DateTime.parse(order['purchaseDate'].toString());
      return orderDate.isAfter(startOfSameWeekLastMonth) &&
          orderDate.isBefore(startOfSameWeekLastMonth.add(const Duration(days: 7))) &&
          order['storeId'].toString() == ordersViewModel.userId.toString();
    }).toList();

    _calculateRevenue(filteredOrdersCurrentWeek, _weeklyRevenueCurrent, 'This Week');
    _calculateRevenue(filteredOrdersLastWeek, _weeklyRevenueLast, 'Last Week');
    _calculateRevenue(filteredOrdersSameWeekLastMonth, _weeklyRevenueMonthLast, 'Same Week Last Month');
  }

  void _calculateRevenue(List<Map<String, dynamic>> filteredOrders, Map<String, double> revenueData, String period) {
    for (var order in filteredOrders) {
      double total = double.parse(order['total'].toString());
      String storeId = order['storeId'].toString();

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
        child: _weeklyRevenueCurrent.isEmpty &&
            _weeklyRevenueLast.isEmpty &&
            _weeklyRevenueMonthLast.isEmpty
            ? const Center(child: Text("Không có doanh thu cho tuần này"))
            : SingleChildScrollView(
          child: Row(
            children: [
              Expanded(flex: 1, child: Container()),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    _buildRevenueCard('This Week', _weeklyRevenueCurrent),
                    _buildRevenueCard('Last Week', _weeklyRevenueLast),
                    _buildRevenueCard('Same Week Last Month', _weeklyRevenueMonthLast),
                  ],
                ),
              ),
              Expanded(flex: 1, child: Container()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRevenueCard(String period, Map<String, double> revenueData) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('$period Revenue:', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
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
