import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX để sử dụng RxList
import '../../../view_model/get_data_viewmodel.dart';
import '../../common/image_extention.dart';
import '../cart/product_grid_view.dart';
import '../text/title.dart';

class ComboOnePerson extends StatelessWidget { // Chuyển thành StatelessWidget
  const ComboOnePerson({super.key});

  @override
  Widget build(BuildContext context) {
    final controllerTestView = Get.put(GetDataViewModel());

    // Sử dụng Obx để lắng nghe sự thay đổi của RxList
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                child: TitleFood(text: 'Combo 1 Person'),
              ),
              SizedBox(
                width: double.infinity,
                child: Obx(() {
                  // Kiểm tra xem sản phẩm đã được tải hay chưa
                  if (controllerTestView.products.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    // Lọc sản phẩm theo category
                    final filteredProducts = controllerTestView.products
                        .where((product) => product['Category'] == 'Combo 1 Người')
                        .toList();

                    // Hiển thị GridView với các sản phẩm đã lọc
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7, // Hiển thị 2 sản phẩm mỗi hàng
                        crossAxisSpacing: 5.0, // Khoảng cách ngang giữa các ô
                        mainAxisSpacing: 5.0, // Khoảng cách dọc giữa các ô
                        childAspectRatio: 0.8, // Tỷ lệ giữa chiều rộng và chiều cao
                      ),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        // Hiển thị sản phẩm phù hợp
                        return ProductGridView(product: product);
                      },
                    );
                  }
                }),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
