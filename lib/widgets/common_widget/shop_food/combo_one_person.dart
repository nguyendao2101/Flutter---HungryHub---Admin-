import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX để sử dụng RxList
import '../../common/image_extention.dart';
import '../cart/product_grid_view.dart';
import '../cart/shop_product_grid_view.dart';
import '../text/title.dart';

class ComboOnePersonShop extends StatelessWidget {
  final RxList<Map<String, dynamic>> listDS;

  const ComboOnePersonShop({super.key, required this.listDS});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                child: TitleFood(
                  text: 'Combo 1 Person',
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Obx(() => // Dùng Obx để theo dõi sự thay đổi của listDS
                listDS.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7, // Hiển thị 2 sản phẩm mỗi hàng
                    crossAxisSpacing: 5.0, // Khoảng cách ngang giữa các ô
                    mainAxisSpacing: 5.0, // Khoảng cách dọc giữa các ô
                    childAspectRatio: 0.8, // Tỷ lệ giữa chiều rộng và chiều cao
                  ),
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: listDS
                      .where((product) =>
                  product['Category'] == 'Combo 1 Người')
                      .length, // Lọc sản phẩm theo category
                  itemBuilder: (context, index) {
                    final filteredProducts = listDS
                        .where((product) =>
                    product['Category'] == 'Combo 1 Người')
                        .toList(); // Lọc sản phẩm ngay từ đầu
                    final product = filteredProducts[index];

                    // Hiển thị sản phẩm phù hợp
                    return ShopProductGridView(
                      product: product,
                    );
                  },
                ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

}
