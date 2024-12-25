// ignore_for_file: prefer_const_constructors_in_immutables, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../view_model/home_view_model.dart';
import '../../common/image_extention.dart';
import '../button/bassic_button.dart';
import '../evaluate/evaluate.dart';
import '../text/title_see_more.dart';

class FoodDetail extends StatefulWidget {
  final Map<String, dynamic> productDetail;

  // Constructor receives productDetail as a map.
  FoodDetail({super.key, required this.productDetail});

  @override
  State<FoodDetail> createState() => _FoodDetailWebState();
}

class _FoodDetailWebState extends State<FoodDetail> {
  final controller = Get.put(HomeViewModel());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Product Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 24,
              height: 24,
              child: PopupMenuButton<int>(
                color: Colors.white,
                offset: const Offset(-10, 15),
                elevation: 1,
                icon: SvgPicture.asset(
                  ImageAsset.more,
                  width: 12,
                  height: 12,
                ),
                padding: EdgeInsets.zero,
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 1,
                      height: 30,
                      child: InkWell(
                        onTap: () {},
                        child: const Text(
                          "Report",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff32343E),
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  ];
                },
              ),
            )
          ],
        ),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1200), // Giới hạn chiều rộng tối đa cho web
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Container(
                        height: 400,
                        width: 500,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            widget.productDetail['ImageUrlFacebook'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.productDetail['Price']} VNĐ',
                              style: const TextStyle(
                                fontSize: 24,
                                color: Color(0xffA02334),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.productDetail['Name'],
                              style: const TextStyle(
                                fontSize: 20,
                                color: Color(0xff32343E),
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.productDetail['Description'],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xff32343E),
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins',
                              ),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                            const SizedBox(height: 20,),
                            const Evaluate(height: 40, width: 80,),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const TitleSeeMore(title: 'Product Review'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
