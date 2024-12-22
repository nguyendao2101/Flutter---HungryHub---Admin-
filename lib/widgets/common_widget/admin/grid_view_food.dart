// // ignore_for_file: use_build_context_synchronously, avoid_print, invalid_use_of_protected_member
//
// import 'dart:math';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
//
// class SliverGridRiders extends StatelessWidget {
//   // ignore: prefer_typing_uninitialized_variables
//   final controller;
//   final RxList<Map<String, dynamic>> listDS;
//   const SliverGridRiders(
//       {super.key, required this.controller, required this.listDS});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final riders = listDS.value;
//       // Sử dụng danh sách ridersListMotoGP thay vì lấy trực tiếp từ controller
//       if (listDS.isEmpty) {
//         return const SliverFillRemaining(
//           child: Center(child: CircularProgressIndicator()),
//         );
//       } else {
//         return SliverPadding(
//           padding: const EdgeInsets.symmetric(horizontal: 60),
//           sliver: SliverGrid(
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 4, // Số cột trong lưới
//               crossAxisSpacing: 10.0,
//               mainAxisSpacing: 10.0,
//               childAspectRatio: 0.8, // Tỉ lệ giữa chiều rộng và chiều cao
//             ),
//             delegate: SliverChildBuilderDelegate(
//                   (BuildContext context, int index) {
//                 var rider =
//                 listDS[index]; // Sử dụng ridersListMotoGP truyền vào
//                 return InkWell(
//                   onTap: () {
//                     // Get.to(() => RiderDetailScreen(rider: rider));
//                   },
//                   child: GridTile(
//                     footer: Container(
//                       padding: const EdgeInsets.all(8.0),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.5),
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '#${rider['Id']}',
//                             style: const TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 rider['Name'],
//                                 style: const TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 30),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               Row(
//                                 children: [
//                                   IconButton(
//                                     icon: const Icon(
//                                       Icons.edit,
//                                       color: Colors.blue,
//                                       size: 30,
//                                     ),
//                                     onPressed: () {
//                                       // Hiển thị dialog chỉnh sửa
//                                       // _showEditDialog(
//                                       //     context, riders[index], index);
//                                     },
//                                   ),
//                                   const SizedBox(
//                                     width: 4,
//                                   ),
//                                   IconButton(
//                                     icon: const Icon(
//                                       Icons.delete,
//                                       color: Colors.red,
//                                       size: 30,
//                                     ),
//                                     onPressed: () async {
//                                       try {
//                                         // Lấy ID của tài liệu từ dữ liệu của calendar
//                                         String documentId = riders[index]['id'];
//
//                                         // Lấy dữ liệu từ Calendar/GrandsPrix
//                                         final snapshot = await FirebaseDatabase
//                                             .instance
//                                             .ref('Riders&Team/Riders/MotoGP')
//                                             .get();
//
//                                         if (snapshot.exists) {
//                                           // Duyệt qua từng nhánh con của Calendar/GrandsPrix
//                                           for (var grandPrixEntry
//                                           in snapshot.children) {
//                                             // Kiểm tra xem documentId có tồn tại trong nhánh này không
//                                             final addCalendarSnapshot =
//                                             grandPrixEntry
//                                                 .child(documentId);
//                                             if (addCalendarSnapshot.exists) {
//                                               // Nếu tồn tại, thực hiện xóa
//                                               await FirebaseDatabase.instance
//                                                   .ref(
//                                                   'Riders&Team/Riders/MotoGP/${grandPrixEntry.key}/$documentId')
//                                                   .remove();
//
//                                               // Nếu việc xóa thành công, xóa mục khỏi danh sách
//                                               listDS.removeAt(index);
//
//                                               // Thoát khỏi vòng lặp sau khi tìm thấy và xóa
//                                               return;
//                                             }
//                                           }
//                                         }
//
//                                         // Lấy dữ liệu từ Calendar/GrandsPrix
//                                         final snapshot2 = await FirebaseDatabase
//                                             .instance
//                                             .ref('Riders&Team/Riders/Moto2')
//                                             .get();
//
//                                         if (snapshot2.exists) {
//                                           // Duyệt qua từng nhánh con của Calendar/AllEvents
//                                           for (var allEventsEntry
//                                           in snapshot2.children) {
//                                             // Kiểm tra xem documentId có tồn tại trong nhánh này không
//                                             final addCalendarSnapshot =
//                                             allEventsEntry
//                                                 .child(documentId);
//                                             if (addCalendarSnapshot.exists) {
//                                               // Nếu tồn tại, thực hiện xóa
//                                               await FirebaseDatabase.instance
//                                                   .ref(
//                                                   'Riders&Team/Riders/Moto2/${allEventsEntry.key}/$documentId')
//                                                   .remove();
//
//                                               // Nếu việc xóa thành công, xóa mục khỏi danh sách
//                                               listDS.removeAt(index);
//
//                                               // Thoát khỏi vòng lặp sau khi tìm thấy và xóa
//                                               return;
//                                             }
//                                           }
//                                         }
//
//                                         // Lấy dữ liệu từ Calendar/GrandsPrix
//                                         final snapshot3 = await FirebaseDatabase
//                                             .instance
//                                             .ref('Riders&Team/Riders/Moto3')
//                                             .get();
//
//                                         if (snapshot3.exists) {
//                                           // Duyệt qua từng nhánh con của Calendar/AllEvents
//                                           for (var allEventsEntry
//                                           in snapshot3.children) {
//                                             // Kiểm tra xem documentId có tồn tại trong nhánh này không
//                                             final addCalendarSnapshot =
//                                             allEventsEntry
//                                                 .child(documentId);
//                                             if (addCalendarSnapshot.exists) {
//                                               // Nếu tồn tại, thực hiện xóa
//                                               await FirebaseDatabase.instance
//                                                   .ref(
//                                                   'Riders&Team/Riders/Moto3/${allEventsEntry.key}/$documentId')
//                                                   .remove();
//
//                                               // Nếu việc xóa thành công, xóa mục khỏi danh sách
//                                               listDS.removeAt(index);
//
//                                               // Thoát khỏi vòng lặp sau khi tìm thấy và xóa
//                                               return;
//                                             }
//                                           }
//                                         }
//
//                                         // Lấy dữ liệu từ Calendar/GrandsPrix
//                                         final snapshot4 = await FirebaseDatabase
//                                             .instance
//                                             .ref('Riders&Team/Riders/MotoE')
//                                             .get();
//
//                                         if (snapshot4.exists) {
//                                           // Duyệt qua từng nhánh con của Calendar/AllEvents
//                                           for (var allEventsEntry
//                                           in snapshot4.children) {
//                                             // Kiểm tra xem documentId có tồn tại trong nhánh này không
//                                             final addCalendarSnapshot =
//                                             allEventsEntry
//                                                 .child(documentId);
//                                             if (addCalendarSnapshot.exists) {
//                                               // Nếu tồn tại, thực hiện xóa
//                                               await FirebaseDatabase.instance
//                                                   .ref(
//                                                   'Riders&Team/Riders/MotoE/${allEventsEntry.key}/$documentId')
//                                                   .remove();
//
//                                               // Nếu việc xóa thành công, xóa mục khỏi danh sách
//                                               listDS.removeAt(index);
//
//                                               // Thoát khỏi vòng lặp sau khi tìm thấy và xóa
//                                               return;
//                                             }
//                                           }
//                                         }
//
//                                         // Nếu không tìm thấy documentId, in ra thông báo lỗi
//                                         print(
//                                             'Không tìm thấy documentId trong các nhánh con.');
//                                       } catch (e) {
//                                         // Xử lý lỗi nếu có vấn đề xảy ra
//                                         print(
//                                             'Lỗi khi xóa dữ liệu từ Realtime Database: $e');
//                                       }
//                                     },
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Image.network(
//                                 rider['ImageCountry'],
//                                 height: 20,
//                               ),
//                               const SizedBox(width: 4),
//                               Text(
//                                 rider['Country'],
//                                 style: const TextStyle(color: Colors.white),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               const SizedBox(width: 4),
//                               const Text('|',
//                                   style: TextStyle(
//                                       color: Colors.grey, fontSize: 20)),
//                               const SizedBox(width: 4),
//                               Text(
//                                 rider['Team'],
//                                 style: const TextStyle(color: Colors.white),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     child: Stack(
//                       fit: StackFit.expand,
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius:
//                             const BorderRadius.all(Radius.circular(8)),
//                             gradient: LinearGradient(
//                               colors: [
//                                 Colors.black,
//                                 _randomColor(),
//                               ],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                           ),
//                         ),
//                         rider['ImageRacer'] != ''
//                             ? Image.network(
//                           rider['ImageRacer'],
//                           fit: BoxFit.cover,
//                         )
//                             : const Icon(Icons.person,
//                             size: 50, color: Colors.grey),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//               childCount: listDS.length, // Số lượng phần tử trong danh sách
//             ),
//           ),
//         );
//       }
//     });
//   }
//
//   // Hàm tạo màu ngẫu nhiên
//   Color _randomColor() {
//     final Random random = Random();
//     return Color.fromARGB(
//       255,
//       random.nextInt(256),
//       random.nextInt(256),
//       random.nextInt(256),
//     );
//   }
//
//
// }
