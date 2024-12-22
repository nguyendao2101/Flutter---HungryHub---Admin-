import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../view_model/get_data_viewmodel.dart';
import '../../../view_model/home_view_model.dart';
import '../evaluate/evaluate.dart';
import '../text/truncated_text.dart';


class ProductGridView extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductGridView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeViewModel());
    final controllerData = Get.put(GetDataViewModel());
    return GestureDetector(
      onTap: (){
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => FoodDetail(productDetail: product,),
        //   ),
        // );
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
                Stack(
                children: [
                ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  product['ImageUrlFacebook'] ?? '',
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    // In thêm thông tin chi tiết về lỗi
                    print("Error loading image: ${error.toString()}");
                    print("StackTrace: $stackTrace");

                    // Trả về hình ảnh mặc định hoặc icon báo lỗi
                    return const Icon(
                      Icons.broken_image,
                      size: 95,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
              Positioned(
                top: 10, // Khoảng cách từ trên
                right: 10, // Khoảng cách từ phải
                child: GestureDetector(
                  onTap: () {
                    // Hàm xử lý khi nhấn vào icon edit
                    print('Edit icon tapped');
                    showEditProductDialog(
                      context,
                      product['id'],
                      product,
                          (updatedData) {
                        controllerData.updateProduct(product['id'], updatedData);
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white.withOpacity(0.8), // Màu nền mờ
                    child: const Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              ],
            ),

        Padding(
                padding: const EdgeInsets.only(right: 4, left: 4, top: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TruncatedText(
                      text: product['Name'],
                      maxWidth: 180,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xff32343E),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      'Giá: ${product['Price']} VND',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xff32343E),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              const Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Evaluate(height: 24, width: 71),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  void showEditProductDialog(BuildContext context, String productId,
      Map<String, dynamic> currentData, Function(Map<String, dynamic>) onSubmit) {
    final TextEditingController nameController =
    TextEditingController(text: currentData['Name']);

    final TextEditingController priceController =
    TextEditingController(text: currentData['Price'].toString());

    final TextEditingController categoryController =
    TextEditingController(text: currentData['Category']);

    final TextEditingController descriptionController =
    TextEditingController(text: currentData['Description']);

    final TextEditingController imageUrlController =
    TextEditingController(text: currentData['ImageUrl']);

    final TextEditingController imageUrlFacebookController =
    TextEditingController(text: currentData['ImageUrlFacebook']);

    final TextEditingController idController =
    TextEditingController(text: currentData['id']);

    final TextEditingController showController =
    TextEditingController(text: currentData['Show'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit product'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(labelText: 'Category'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: imageUrlController,
                  decoration: InputDecoration(labelText: 'Image URL'),
                ),
                TextField(
                  controller: imageUrlFacebookController,
                  decoration: InputDecoration(labelText: 'Image URL Facebook'),
                ),
                TextField(
                  controller: idController,
                  decoration: InputDecoration(labelText: 'Id'),
                ),
                TextField(
                  controller: showController,
                  decoration: InputDecoration(labelText: 'Show'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedData = {
                  'Name': nameController.text,
                  'Price': int.tryParse(priceController.text) ?? 0,
                  'Category': categoryController.text,
                  'Description': descriptionController.text,
                  'ImageUrl': imageUrlController.text,
                  'ImageUrlFacebook': imageUrlFacebookController.text,
                  'id': idController.text,
                  'Show': int.tryParse(showController.text) ?? 0,

                };
                onSubmit(updatedData);
                Navigator.pop(context);
              },
              child: Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

}
