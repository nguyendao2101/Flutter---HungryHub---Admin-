import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry_hub_web/widgets/common_widget/admin/burger.dart';
import 'package:hungry_hub_web/widgets/common_widget/admin/chickend.dart';
import 'package:hungry_hub_web/widgets/common_widget/admin/combo_group.dart';
import 'package:hungry_hub_web/widgets/common_widget/admin/combo_one_person.dart';
import 'package:hungry_hub_web/widgets/common_widget/admin/drinks.dart';
import 'package:hungry_hub_web/widgets/common_widget/admin/snacks.dart';

import '../../../view_model/get_data_viewmodel.dart';
import '../../../widgets/common_widget/admin/add_food.dart';

class BrowseFood extends StatefulWidget{
  const BrowseFood({super.key});

  @override
  State<BrowseFood> createState() => _BrowseFoodState();
}

class _BrowseFoodState extends State<BrowseFood> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final controllerTestView = Get.put(GetDataViewModel());
  bool _isLoadingProducts = true;

  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    // Initialize TabController with 6 tabs and the current index set to 0
    _tabController = TabController(length: 7, vsync: this);
    _loadProducts();
  }
  Future<void> _loadProducts() async {
    await controllerTestView.fetchProducts();
    setState(() {
      _products = controllerTestView.products;
      _isLoadingProducts = false;
    });
  }

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
                          Tab(text: 'Combo 1 Person'),
                          Tab(text: 'Group Combo'),
                          Tab(text: 'Fried Chicken - Roast Chicken'),
                          Tab(text: 'Burger - Rice - Spaghetti'),
                          Tab(text: 'Snacks'),
                          Tab(text: 'Drinks And DessertsView'),
                          Tab(text: 'Add Item Food'),
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
                ComboOnePerson(listDS: controllerTestView.products,),
                ComboGroup(listDS: controllerTestView.products,),
                Chickend(listDS: controllerTestView.products,),
                Burger(listDS: controllerTestView.products,),
                Snacks(listDS: controllerTestView.products,),
                Drinks(listDS: controllerTestView.products,),
                AddFood(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
