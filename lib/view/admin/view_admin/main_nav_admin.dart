import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry_hub_web/view/admin/view_admin/browse_food.dart';
import 'package:hungry_hub_web/view/admin/view_admin/browse_store.dart';
import 'package:hungry_hub_web/view_model/admin/main_nav_view_model.dart';
import 'package:hungry_hub_web/widgets/common/image_extention.dart';

import '../../../widgets/common_widget/icon_text_row.dart';

class MainNavAdmin extends StatefulWidget {
  const MainNavAdmin({super.key});

  @override
  State<MainNavAdmin> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MainNavAdmin> with SingleTickerProviderStateMixin{
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    // Initialize TabController with 6 tabs and the current index set to 0
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainNavViewModel());
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
                  title: 'Browse Store',
                  onTap: () {
                    // Get.to(() => const CalendarView());
                  }),
              _dividerDrawer(),
              IconTextRow(
                  title: 'Browse Food',
                  onTap: () {
                    // Get.to(() => const ResultsAndStandingsResultsView());
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
                        _textTopAppbar('#ADMIN'),
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
                            controller: _tabController,
                            indicatorColor: Colors.red,
                            indicatorWeight: 1,
                            labelColor: Colors.white,
                            labelStyle: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            isScrollable: true,
                            tabs: const [
                              Tab(text: 'Browse Store'),
                              Tab(text: 'Browse Food'),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: -30,
                        left:
                        0, // Hoặc left: 0 nếu bạn muốn hình ảnh nằm bên trái
                        child: InkWell(
                          onTap: () {},
                          child: Image.asset(
                            ImageAsset.loadLogoApp,
                            height: 120,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 14,
                        right:
                        0, // Hoặc left: 0 nếu bạn muốn hình ảnh nằm bên trái
                        child: InkWell(
                          onTap: () {
                            // Get.to(() => const InfoUserView());
                          },
                          child: Image.asset(
                            ImageAsset.users,
                            height: 32,
                            width: 32,
                          ),
                        ),
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
                colors: [Colors.black, Color(0xff4C585B)], // Các màu gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            BrowseStore(),
            BrowseFood()
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
      style: TextStyle(
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
            style: TextStyle(
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
