// ignore_for_file: avoid_print

import 'package:emailjs/emailjs.dart';
import 'package:emailjs/emailjs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:emailjs/emailjs.dart' as emailjs;

class HomeViewModel extends GetxController {
  late TextEditingController searchController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final List<Map<String, dynamic>> shoppingCart = [];
  final RxList<Map<String, dynamic>> favoriteProducts = <Map<String, dynamic>>[].obs;
  final formKey = GlobalKey<FormState>();
  final _userData = {}.obs;
  String _userId = '';
  bool isListening = false;
  RxMap get userData => _userData;

  final RxMap _browseShopData = {}.obs;
  RxMap get browseShopData => _browseShopData;

  // Biến lưu thông tin người dùng từ cả hai đường dẫn 'users/$_userId' và 'browseShop/$_userId'
  Map<String, dynamic> currentUserInfo = {};

  @override
  void onInit() {
    super.onInit();
    _initializeUserId();
  }

  // Lấy User ID từ FirebaseAuth
  void _initializeUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
      await _getUserData();
      await _getUserIdFromBrowseShop();
    }
  }

  // Lấy thông tin người dùng từ 'browseShop/$_userId' và sau đó kiểm tra với 'users/$_userId'
  Future<void> _getUserData() async {
    DatabaseReference userRef = _database.child('users/$_userId');
    DatabaseReference browseShopRef = _database.child('browseShop/$_userId');

    // Lấy dữ liệu từ 'browseShop/$_userId'
    DataSnapshot browseShopSnapshot = await browseShopRef.get();
    if (browseShopSnapshot.exists) {
      _browseShopData.value = Map<String, dynamic>.from(browseShopSnapshot.value as Map);
      currentUserInfo = Map<String, dynamic>.from(browseShopSnapshot.value as Map);
    } else {
      _browseShopData.value = {};
      print("BrowseShop data not found.");
    }

    // Kiểm tra và lấy dữ liệu từ 'users/$_userId'
    DataSnapshot userSnapshot = await userRef.get();
    if (userSnapshot.exists) {
      Map<String, dynamic> userInfo = Map<String, dynamic>.from(userSnapshot.value as Map);
      // Cập nhật dữ liệu của người dùng nếu dữ liệu từ 'users' tồn tại
      currentUserInfo.addAll(userInfo);
    }

    _userData.value = currentUserInfo; // Lưu thông tin vào _userData để cập nhật UI
    update();
  }

  // Cập nhật thông tin người dùng ở cả hai đường dẫn: 'users/$_userId' và 'browseShop/$_userId'
  Future<void> updateUserData(Map<String, dynamic> newUserData) async {
    try {
      DatabaseReference userRef = _database.child('users/$_userId');
      DatabaseReference browseShopRef = _database.child('browseShop/$_userId');

      // Cập nhật thông tin người dùng
      await userRef.update(newUserData);
      await browseShopRef.update(newUserData);

      // Cập nhật lại dữ liệu local sau khi thay đổi thành công
      currentUserInfo.addAll(newUserData);
      _userData.value = currentUserInfo;
      _browseShopData.value = currentUserInfo;

      update();  // Cập nhật UI

      Get.snackbar(
        "Success",
        "User information updated successfully in both sections!",
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update user information: $e",
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> _getUserIdFromBrowseShop() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;

      // Fetch user data from 'browseShop/$_userId'
      final browseShopSnapshot = await _database.child('browseShop/$_userId').get();
      if (browseShopSnapshot.exists) {
        _browseShopData.value = Map<String, dynamic>.from(browseShopSnapshot.value as Map);

        // Now get the corresponding user data from 'users/$_userId'
        final userSnapshot = await _database.child('users/$_userId').get();
        if (userSnapshot.exists) {
          _userData.value = Map<String, dynamic>.from(userSnapshot.value as Map);
        } else {
          _userData.value = {}; // If no data, initialize with empty map
        }
      } else {
        print("No data found in browseShop for $_userId");
        _browseShopData.value = {};
      }
    }
  }

  // Giao diện để sửa thông tin người dùng
  Widget editUserInfoUI() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: currentUserInfo['name'] ?? '',
            decoration: InputDecoration(labelText: 'Name'),
            onSaved: (value) {
              currentUserInfo['name'] = value;
            },
          ),
          TextFormField(
            initialValue: currentUserInfo['email'] ?? '',
            decoration: InputDecoration(labelText: 'Email'),
            onSaved: (value) {
              currentUserInfo['email'] = value;
            },
          ),
          TextFormField(
            initialValue: currentUserInfo['address'] ?? '',
            decoration: InputDecoration(labelText: 'Address'),
            onSaved: (value) {
              currentUserInfo['address'] = value;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () async {
                  formKey.currentState?.save();
                  await updateUserData(currentUserInfo); // Gọi hàm cập nhật thông tin
                },
                child: Text('Update Info'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void sendEmail(String email, String name) async {
    try {
      await emailjs.send(
        'service_djr43ta', //YOUR_SERVICE_ID
        'template_zy39a4p', //YOUR_TEMPLATE_ID
        {
          'from_name': 'Chúc mừng bạn đã đăng ký thành công tài khoản Shop trên HungryHub',
          'to_name': name,
          'message':'''
              Kính gửi $name,

              Cảm ơn bạn đã tham gia cộng đồng HungryHub! Chúng tôi rất vui mừng thông báo rằng tài khoản Shop của bạn, **$name**, đã được đăng ký thành công trên nền tảng của chúng tôi.

              ### Thông tin tài khoản:
              - **Tên shop:** $name (*Vui lòng truy cập vào shop để cập nhật thông tin)
              - **Email:** $email

              Từ bây giờ, bạn có thể dễ dàng quản lý và bán sản phẩm trên HungryHub, nơi sẽ giúp bạn kết nối với hàng triệu khách hàng yêu thích món gà ngon và chất lượng.

              ### Những lợi ích bạn nhận được:
              - Tiếp cận khách hàng tiềm năng với nền tảng bán hàng uy tín.
              - Quản lý đơn hàng và sản phẩm nhanh chóng qua ứng dụng.
              - Nhận hỗ trợ từ đội ngũ HungryHub 24/7 để giải quyết các vấn đề kinh doanh của bạn.

              Chúng tôi cam kết sẽ đồng hành cùng bạn trong suốt hành trình phát triển cửa hàng trên HungryHub.

              Nếu bạn có bất kỳ câu hỏi nào hoặc cần hỗ trợ, đừng ngần ngại liên hệ với chúng tôi qua email hoặc số điện thoại hỗ trợ bên dưới.

              Chúc bạn kinh doanh thuận lợi và gặt hái nhiều thành công cùng HungryHub!

              **Trân trọng,**
              **Đội ngũ HungryHub**
              Email: hungryhub.support@gmail.com
              SĐT: 1800-8386
              ''',
          'to_email': email,
          'reply_to': 'hungryhubb1@gmail.com',
        },
        const emailjs.Options(
            publicKey: 'L79fWPt-XB4LAMsEl',  //YOUR_PUBLIC_KEY
            privateKey: 'jP61LI4QUXjPkvWVeQDRT',  //YOUR_PRIVATE_KEY
            limitRate: const emailjs.LimitRate(
              id: 'app',
              throttle: 10000,
            )),
      );
      print('SUCCESS!');
    } catch (error) {
      if (error is emailjs.EmailJSResponseStatus) {
        print('ERROR... $error');
      }
      print(error.toString());
    }
  }

  // //gui mail xac nhan tk shop
  // Future<void> sendEmail(String email, String code) async {
  //   String username = 'hungryhubb1@gmail.com'; // Email gửi
  //   String password = 'scra wnmq uhhm ovuc'; // Mật khẩu email gửi
  //
  //   final smtpServer = gmail(username, password); // Sử dụng Gmail
  //
  //   final message = Message()
  //     ..from = Address(username, 'HungryHub')
  //     ..recipients.add(email) // Email nhận
  //     ..subject = 'Mã xác minh tài khoản'
  //     ..text =
  //         'Chào bạn!\nCảm ơn bạn đã quan tâm và đăng ký tài khoản HungryHub\nMã xác minh của bạn là: $code\nChúc bạn có những giây phút mua hàng vui vẻ!!\nĐừng quên đánh giá 5 sao cho sản phẩm nhé!!';
  //
  //   try {
  //     await send(message, smtpServer);
  //     print('Email gửi thành công');
  //   } catch (e) {
  //     print('Gửi email thất bại: $e');
  //   }
  // }
  // Future<void> sendEmail(String email, String shopName) async {
  //   String username = 'hungryhubb1@gmail.com'; // Email gửi
  //   String password = 'nrhc ernj lejs fpyi'; // Mật khẩu email gửi
  //
  //   final smtpServer = gmail(username, password); // Sử dụng Gmail
  //
  //   final message = Message()
  //     ..from = Address(username, 'HungryHub')
  //     ..recipients.add(email) // Email nhận
  //     ..subject = 'Chúc mừng bạn đã đăng ký thành công tài khoản Shop trên HungryHub'
  //     ..text = '''
  //             Kính gửi [Tên người dùng],
  //
  //             Cảm ơn bạn đã tham gia cộng đồng HungryHub! Chúng tôi rất vui mừng thông báo rằng tài khoản Shop của bạn, **$shopName**, đã được đăng ký thành công trên nền tảng của chúng tôi.
  //
  //             ### Thông tin tài khoản:
  //             - **Tên shop:** $shopName (*Vui lòng truy cập vào shop để cập nhật thông tin)
  //             - **Email:** $email
  //
  //             Từ bây giờ, bạn có thể dễ dàng quản lý và bán sản phẩm trên HungryHub, nơi sẽ giúp bạn kết nối với hàng triệu khách hàng yêu thích món gà ngon và chất lượng.
  //
  //             ### Những lợi ích bạn nhận được:
  //             - Tiếp cận khách hàng tiềm năng với nền tảng bán hàng uy tín.
  //             - Quản lý đơn hàng và sản phẩm nhanh chóng qua ứng dụng.
  //             - Nhận hỗ trợ từ đội ngũ HungryHub 24/7 để giải quyết các vấn đề kinh doanh của bạn.
  //
  //             Chúng tôi cam kết sẽ đồng hành cùng bạn trong suốt hành trình phát triển cửa hàng trên HungryHub.
  //
  //             Nếu bạn có bất kỳ câu hỏi nào hoặc cần hỗ trợ, đừng ngần ngại liên hệ với chúng tôi qua email hoặc số điện thoại hỗ trợ bên dưới.
  //
  //             Chúc bạn kinh doanh thuận lợi và gặt hái nhiều thành công cùng HungryHub!
  //
  //             **Trân trọng,**
  //             **Đội ngũ HungryHub**
  //             Email: hungryhub.support@gmail.com
  //             SĐT: 1800-XXXX
  //             ''';
  //   try {
  //     await send(message, smtpServer);
  //     print('Email gửi thành công');
  //   } catch (e) {
  //     print('Gửi email thất bại: $e');
  //   }
  // }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
