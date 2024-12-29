import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../view_model/get_data_viewmodel.dart';
import '../../../view_model/orders_view_model.dart';

class YearView extends StatefulWidget {
  const YearView({super.key});

  @override
  State<YearView> createState() => _YearViewState();
}

class _YearViewState extends State<YearView> {
  final getDataViewModel = Get.put(GetDataViewModel());
  final ordersViewModel = Get.put(OrdersViewModel());

  List<Map<String, dynamic>> _orderTracking = [];
  Map<String, double> _yearlyRevenueCurrent = {};
  Map<String, double> _yearlyRevenueLast = {};
  Map<String, double> _yearlyRevenueTwoYearsAgo = {};
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
    _yearlyRevenueCurrent.clear();
    _yearlyRevenueLast.clear();
    _yearlyRevenueTwoYearsAgo.clear();

    DateTime now = DateTime.now();
    DateTime startOfThisYear = DateTime(now.year, 1, 1);
    DateTime startOfLastYear = DateTime(now.year - 1, 1, 1);
    DateTime startOfTwoYearsAgo = DateTime(now.year - 2, 1, 1);

    var filteredOrdersCurrentYear = _orderTracking.where((order) {
      DateTime orderDate = DateTime.parse(order['purchaseDate'].toString());
      return orderDate.isAfter(startOfThisYear) &&
          orderDate.isBefore(DateTime(startOfThisYear.year + 1, 1, 1)) &&
          order['storeId'].toString() == ordersViewModel.userId.toString();
    }).toList();

    var filteredOrdersLastYear = _orderTracking.where((order) {
      DateTime orderDate = DateTime.parse(order['purchaseDate'].toString());
      return orderDate.isAfter(startOfLastYear) &&
          orderDate.isBefore(DateTime(startOfLastYear.year + 1, 1, 1)) &&
          order['storeId'].toString() == ordersViewModel.userId.toString();
    }).toList();

    var filteredOrdersTwoYearsAgo = _orderTracking.where((order) {
      DateTime orderDate = DateTime.parse(order['purchaseDate'].toString());
      return orderDate.isAfter(startOfTwoYearsAgo) &&
          orderDate.isBefore(DateTime(startOfTwoYearsAgo.year + 1, 1, 1)) &&
          order['storeId'].toString() == ordersViewModel.userId.toString();
    }).toList();

    _calculateRevenue(
        filteredOrdersCurrentYear, _yearlyRevenueCurrent, 'This Year');
    _calculateRevenue(filteredOrdersLastYear, _yearlyRevenueLast, 'Last Year');
    _calculateRevenue(
        filteredOrdersTwoYearsAgo, _yearlyRevenueTwoYearsAgo, 'Two Years Ago');
  }

  void _calculateRevenue(List<Map<String, dynamic>> filteredOrders,
      Map<String, double> revenueData, String period) {
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
              child: _yearlyRevenueCurrent.isEmpty &&
                      _yearlyRevenueLast.isEmpty &&
                      _yearlyRevenueTwoYearsAgo.isEmpty
                  ? const Center(child: Text("Không có doanh thu cho năm này"))
                  : SingleChildScrollView(
                      child: Row(
                        children: [
                          Expanded(flex: 1, child: Container()),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                _buildRevenueCard(
                                    'This Year', _yearlyRevenueCurrent),
                                _buildRevenueCard(
                                    'Last Year', _yearlyRevenueLast),
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
        const SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('$period Revenue:',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        for (var storeId in revenueData.keys) ...[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 7)
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Shop ID: $storeId',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600)),
                const Divider(),
                Text('Total Revenue: ${revenueData[storeId]} VND',
                    style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xffA02334),
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
