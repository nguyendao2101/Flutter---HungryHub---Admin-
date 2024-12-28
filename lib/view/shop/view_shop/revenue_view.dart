import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry_hub_web/widgets/common_widget/admin/burger.dart';
import 'package:hungry_hub_web/widgets/common_widget/admin/chickend.dart';
import 'package:hungry_hub_web/widgets/common_widget/admin/combo_group.dart';
import 'package:hungry_hub_web/widgets/common_widget/admin/combo_one_person.dart';
import 'package:hungry_hub_web/widgets/common_widget/admin/drinks.dart';
import 'package:hungry_hub_web/widgets/common_widget/admin/snacks.dart';
import 'package:hungry_hub_web/widgets/common_widget/shop/confirm.dart';
import 'package:hungry_hub_web/widgets/common_widget/shop/day_view.dart';
import 'package:hungry_hub_web/widgets/common_widget/shop/delivered.dart';
import 'package:hungry_hub_web/widgets/common_widget/shop/month_view.dart';
import 'package:hungry_hub_web/widgets/common_widget/shop/pending_delivery.dart';
import 'package:hungry_hub_web/widgets/common_widget/shop/quarter_view.dart';
import 'package:hungry_hub_web/widgets/common_widget/shop/week_view.dart';
import 'package:hungry_hub_web/widgets/common_widget/shop/year_view.dart';

import '../../../view_model/get_data_viewmodel.dart';
import '../../../widgets/common_widget/admin/add_food.dart';

class RevenueView extends StatefulWidget{
  const RevenueView({super.key});

  @override
  State<RevenueView> createState() => _RevenueViewState();
}

class _RevenueViewState extends State<RevenueView> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final controllerTestView = Get.put(GetDataViewModel());
  bool _isLoadingProducts = true;

  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    // Initialize TabController with 6 tabs and the current index set to 0
    _tabController = TabController(length: 4, vsync: this);

  }
  // Future<void> _loadProducts() async {
  //   await controllerTestView.fetchProducts();
  //   setState(() {
  //     _products = controllerTestView.products;
  //     _isLoadingProducts = false;
  //   });
  // }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true, // Giúp AppBar cuộn theo nội dung
            snap: true, // AppBar xuất hiện ngay khi người dùng vuốt nhẹ lên
            pinned: false, // Không giữ lại AppBar khi cuộn
            primary: false, // Vô hiệu hóa việc tính toán AppBar với phần đầu
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              background: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TabBar(
                        controller: _tabController,
                        indicatorColor: Colors.red,
                        indicatorWeight: 1,
                        labelColor: Colors.red,
                        labelStyle: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        isScrollable: true,
                        tabs: const [
                          Tab(text: 'Day'),
                          Tab(text: 'Week'),
                          Tab(text: 'Month'),
                          Tab(text: 'Year'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                DayView(),
                WeekView(),
                MonthView(),
                YearView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
