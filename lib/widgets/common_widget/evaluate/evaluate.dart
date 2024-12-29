import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../view_model/elvaluate_product_view_model.dart';
import '../../common/image_extention.dart';

class Evaluate extends StatefulWidget {
  final Map<String, dynamic> productDetail;
  final double height;
  final double width;
  const Evaluate({super.key, required this.height, required this.width, required this.productDetail});

  @override
  State<Evaluate> createState() => _EvaluateState();
}

class _EvaluateState extends State<Evaluate> {
  final controllerEvalua = Get.put(ElvaluateProductViewModel());
  double? averageRatingValue;

  @override
  void initState() {
    super.initState();
    _initializeAverageRating();
  }
  Future<void> _initializeAverageRating() async {
    try {
      averageRatingValue = await controllerEvalua.getAverageEvaluationByProduct(widget.productDetail['id']);
      setState(() {}); // Cập nhật UI sau khi lấy được giá trị
    } catch (e) {
      print('Error fetching average rating: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      future: controllerEvalua.getAverageEvaluationByProduct(widget.productDetail['id']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            color: Colors.purpleAccent,
          );
        } else if (snapshot.hasError) {
          return const Text(
            'Error fetching rating',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
            ),
          );
        } else if (snapshot.hasData) {
          return Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              color: const Color(0xffD42323),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(ImageAsset.starRating),
                  Text(
                    averageRatingValue!.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Text(
            'No data',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
            ),
          );
        }
      },
    );
  }

}
