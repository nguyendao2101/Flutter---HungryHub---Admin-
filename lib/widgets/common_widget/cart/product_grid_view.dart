import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../view_model/home_view_model.dart';
import '../evaluate/evaluate.dart';
import '../text/truncated_text.dart';


class ProductGridView extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductGridView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeViewModel());
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
                      product['ImageUrl'] ?? '',
                      width: double.infinity,
                      height: 95,
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
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 4, left: 4, top: 20, bottom: 10),
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
              Column(
                children: [
                  const Row(
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
}
