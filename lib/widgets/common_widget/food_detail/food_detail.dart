// ignore_for_file: prefer_const_constructors_in_immutables, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../view_model/elvaluate_product_view_model.dart';
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
  final controllerEvalua = Get.put(ElvaluateProductViewModel());
  final TextEditingController _commentController =
      TextEditingController(); // Controller cho TextField
  double _rating = 0.0; // Biến lưu đánh giá sao
  late Future<double> averageRating; // Lưu trữ giá trị trung bình đánh giá
  late Future<List<Map<String, String>>>
      evaluations; // Lưu trữ danh sách đánh giá
  double? averageRatingValue;

  @override
  void initState() {
    super.initState();
    averageRating = controllerEvalua
        .getAverageEvaluationByProduct(widget.productDetail['id']);
    evaluations =
        controllerEvalua.getEvaluationsByProduct(widget.productDetail['id']);
    _initializeAverageRating();
  }

  Future<void> _initializeAverageRating() async {
    try {
      averageRatingValue = await controllerEvalua
          .getAverageEvaluationByProduct(widget.productDetail['id']);
      setState(() {}); // Cập nhật UI sau khi lấy được giá trị
    } catch (e) {
      print('Error fetching average rating: $e');
    }
  }

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
          constraints: BoxConstraints(
              maxWidth: 1200), // Giới hạn chiều rộng tối đa cho web
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
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
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
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        FutureBuilder<double>(
                          future: averageRating,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Average Rating:',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff32343E),
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins',
                                    )),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      index < snapshot.data!
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.orange,
                                      size: 30,
                                    );
                                  }),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const TitleSeeMore(title: 'Product Review'),
                FutureBuilder<List<Map<String, String>>>(
                  future: evaluations,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: snapshot.data!
                          .map(
                            (eval) => ListTile(
                              title: Column(
                                children: [
                                  const Divider(),
                                  Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey.shade300,
                                        ),
                                        child: ClipOval(
                                          child: Image.asset(
                                            ImageAsset.users,
                                            height: 40,
                                            width: 40,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            eval['nameUser'] ?? 'Unknown',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Color(0xff32343E),
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                          Text(
                                            eval['comment'] ?? 'No comment',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Color(0xff32343E),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Poppins',
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
