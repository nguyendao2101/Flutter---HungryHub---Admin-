import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry_hub_web/view/shop/view_shop/evaluate_view.dart';
import 'package:hungry_hub_web/view/shop/view_shop/order_view.dart';
import 'package:hungry_hub_web/view/shop/view_shop/revenue_view.dart';
import 'package:hungry_hub_web/view/shop/view_shop/store_management_view.dart';

import '../../../view_model/shop/main_nav_view_model.dart';
import '../../../widgets/common/image_extention.dart';
import '../../../widgets/common_widget/icon_text_row.dart';
import '../../admin/view_admin/browse_food.dart';
import '../../admin/view_admin/browse_store.dart';
import '../../login_view.dart';

class MainNavShop extends StatefulWidget {
  final int initialIndex;
  const MainNavShop({super.key, required this.initialIndex});

  @override
  State<MainNavShop> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MainNavShop> with SingleTickerProviderStateMixin{
  TabController? tabController;
  int selectTab = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
        length: 4, vsync: this, initialIndex: widget.initialIndex);

    tabController?.addListener(() {
      selectTab = tabController?.index ?? 0;
      setState(() {});
    });
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainNavShopViewModel());
    var media = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Scaffold(
        key: controller.scaffoldKey,
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 190,
                child: DrawerHeader(
                  decoration:
                  BoxDecoration(color: Colors.grey.withOpacity(0.03)),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Image.asset(
                        ImageAsset.loadLogoApp,
                        height: 120,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
              IconTextRow(
                  title: 'Oder',
                  onTap: () {
                    Get.to(() => const MainNavShop(initialIndex: 0,));
                    controller.closeDrawer();
                  }),
              _dividerDrawer(),
              IconTextRow(
                  title: 'Revenue',
                  onTap: () {
                    Get.to(() => const MainNavShop(initialIndex: 1,));
                    controller.closeDrawer();
                  }),
              _dividerDrawer(),
              IconTextRow(
                  title: 'Evaluate',
                  onTap: () {
                    Get.to(() => const MainNavShop(initialIndex: 1,));
                    controller.closeDrawer();
                  }),
              _dividerDrawer(),
              IconTextRow(
                  title: 'Store management',
                  onTap: () {
                    Get.to(() => const MainNavShop(initialIndex: 1,));
                    controller.closeDrawer();
                  }),
              _dividerDrawer(),
            ],
          ),
        ),
        appBar: AppBar(
          toolbarHeight: 120, // Chiều cao tùy chỉnh cho AppBar
          title: SizedBox(
            height: 120,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _textTopAppbar('#SHOP'),
                        _SizeBoxW24(),
                        _textTopAppbar('#GKT_Team'),
                        _SizeBoxW24(),
                        _textTopAppbar('Menu'),
                        _SizeBoxW24(),
                        _textTopAppbar('Store'),
                        _SizeBoxW24(),
                        _textTopAppbar('Order'),
                        _SizeBoxW24(),
                        _textTopAppbar('Store'),
                        _SizeBoxW24(),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                          child: const Text('SUBSCRIBE'),
                        ),
                        _SizeBoxW24(),
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: VerticalDivider(
                            width: 1, // Chiều rộng của đường kẻ
                            thickness: 2, // Độ dày của đường kẻ
                            color: Colors.grey, // Màu sắc của đường kẻ
                          ),
                        ),
                        _SizeBoxW24(),
                        // Image.asset(
                        //   ImageAssest.logoWebMoto,
                        //   height: 160,
                        // )
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 0.5,
                  color: Colors.grey[400],
                ),
                Expanded(
                  flex: 2,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 48),
                          child: TabBar(
                            controller: tabController,
                            indicatorColor: Colors.red,
                            indicatorWeight: 1,
                            labelColor: Colors.white,
                            labelStyle: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            isScrollable: true,
                            tabs: const [
                              Tab(text: 'Oder'),
                              Tab(text: 'Revenue'),
                              Tab(text: 'Evaluate'),
                              Tab(text: 'Store Management'),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: -30,
                        left:
                        0, // Hoặc left: 0 nếu bạn muốn hình ảnh nằm bên trái
                        child: InkWell(
                          onTap: () {
                            // Get.to(() => LoginView());
                          },
                          child: Image.asset(
                            ImageAsset.loadLogoApp,
                            height: 120,
                          ),
                        ),
                      ),
                      Positioned(
                          top: 14,
                          right:
                          16, // Hoặc left: 0 nếu bạn muốn hình ảnh nằm bên trái
                          child: SizedBox(
                            width: 48, // Tăng kích thước để dễ nhấn hơn
                            height: 48,
                            child: PopupMenuButton<int>(
                              color: Colors.white,
                              offset: const Offset(-10, 15),
                              elevation: 1,
                              icon: Image.asset(ImageAsset.users, height: 48,),
                              padding: EdgeInsets.zero,
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    value: 1,
                                    height: 40,  // Đặt chiều cao của PopupMenuItem
                                    padding: EdgeInsets.zero, // Xóa padding mặc định
                                    child: InkWell(
                                      onTap: () {
                                        Get.offAll(() => const LoginView());
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,  // Chỉ chiếm không gian đủ cho các phần tử bên trong
                                        children: [
                                          const SizedBox(width: 32),  // Thêm khoảng cách giữa ảnh và text
                                          Image.asset(
                                            ImageAsset.logOut,
                                            height: 20,  // Điều chỉnh kích thước ảnh sao cho phù hợp
                                            width: 20,
                                          ),
                                          const SizedBox(width: 20),  // Thêm khoảng cách giữa ảnh và text
                                          const Text(
                                            "Log out",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff32343E),
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ];
                              },
                            ),
                          )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Color(0xff8D0B41)], // Các màu gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            const OrderView(),
            const RevenueView(),
            const EvaluateView(),
            const StoreManagementView(),
          ],
        ),
      ),
    );
  }
  Padding _dividerDrawer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Divider(
        thickness: 0.5,
        color: Colors.grey[400],
      ),
    );
  }
  Text _textTopAppbar(String text) {
    return Text(
      text,
      style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins'
      ),
    );
  }

  RichText _richTextTopAppbar(String text, String textt) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text,
            style: const TextStyle(
                color: Colors.grey, // Màu chữ
                fontWeight: FontWeight.bold, // Đậm
                fontSize: 12, // Kích thước chữ
                fontFamily: 'Poppins'
            ),
          ),
          TextSpan(
            text: textt,
            style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold, // Màu chữ
                fontSize: 12, // Kích thước chữ
                fontFamily: 'Poppins'
            ),
          ),
        ],
      ),
    );
  }
  SizedBox _SizeBoxW24() {
    return const SizedBox(
      width: 24,
    );
  }
}