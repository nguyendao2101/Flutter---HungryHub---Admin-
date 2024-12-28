import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../view_model/get_data_viewmodel.dart';
import '../../../view_model/orders_view_model.dart'; // Định dạng ngày tháng

class MonthView extends StatefulWidget {
  const MonthView({super.key});

  @override
  State<MonthView> createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView> {
  final getDataViewModel = Get.put(GetDataViewModel());
  final ordersViewModel = Get.put(OrdersViewModel());

  List<Map<String, dynamic>> _orderTracking = [];
  Map<String, double> _monthlyRevenueCurrent = {};
  Map<String, double> _monthlyRevenueLast = {};
  Map<String, double> _monthlyRevenueYearLast = {};
  bool _isLoadingOrderTracking = true;

  @override
  void initState() {
    super.initState();
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
        _filterAndCalculateRevenue();
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

  void _filterAndCalculateRevenue() {
    _monthlyRevenueCurrent.clear();
    _monthlyRevenueLast.clear();
    _monthlyRevenueYearLast.clear();

    DateTime now = DateTime.now();
    DateTime startOfThisMonth = DateTime(now.year, now.month, 1);
    DateTime startOfLastMonth = DateTime(now.year, now.month - 1, 1);
    DateTime startOfSameMonthLastYear = DateTime(now.year - 1, now.month, 1);

    var filteredOrdersCurrentMonth = _orderTracking.where((order) {
      DateTime orderDate = DateTime.parse(order['purchaseDate'].toString());
      return orderDate.isAfter(startOfThisMonth) &&
          orderDate.isBefore(DateTime(startOfThisMonth.year, startOfThisMonth.month + 1)) &&
          order['storeId'].toString() == ordersViewModel.userId.toString();
    }).toList();

    var filteredOrdersLastMonth = _orderTracking.where((order) {
      DateTime orderDate = DateTime.parse(order['purchaseDate'].toString());
      return orderDate.isAfter(startOfLastMonth) &&
          orderDate.isBefore(DateTime(startOfLastMonth.year, startOfLastMonth.month + 1)) &&
          order['storeId'].toString() == ordersViewModel.userId.toString();
    }).toList();

    var filteredOrdersSameMonthLastYear = _orderTracking.where((order) {
      DateTime orderDate = DateTime.parse(order['purchaseDate'].toString());
      return orderDate.isAfter(startOfSameMonthLastYear) &&
          orderDate.isBefore(DateTime(startOfSameMonthLastYear.year, startOfSameMonthLastYear.month + 1)) &&
          order['storeId'].toString() == ordersViewModel.userId.toString();
    }).toList();

    _calculateRevenue(filteredOrdersCurrentMonth, _monthlyRevenueCurrent, 'This Month');
    _calculateRevenue(filteredOrdersLastMonth, _monthlyRevenueLast, 'Last Month');
    _calculateRevenue(filteredOrdersSameMonthLastYear, _monthlyRevenueYearLast, 'Same Month Last Year');
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
        child: _monthlyRevenueCurrent.isEmpty &&
            _monthlyRevenueLast.isEmpty &&
            _monthlyRevenueYearLast.isEmpty
            ? const Center(child: Text("Không có doanh thu cho tháng này"))
            : SingleChildScrollView(
          child: Row(
            children: [
              Expanded(flex: 1,child: Container()),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildRevenueCard('This Month', _monthlyRevenueCurrent),
                    _buildRevenueCard('Last Month', _monthlyRevenueLast),
                    _buildRevenueCard('Same Month Last Year', _monthlyRevenueYearLast),
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
