import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddFood extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController imageUrlFacebookController = TextEditingController();
  final TextEditingController showController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  Future<void> addProduct(Map<String, dynamic> productData, String id) async {
    try {
      // Sử dụng ID từ người dùng nhập vào
      await _firestore.collection('products').doc(id).set(productData);

      // Log kết quả
      print('Sản phẩm với ID $id đã được thêm thành công.');
    } catch (e) {
      print('Lỗi khi thêm sản phẩm: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm sản phẩm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                decoration: InputDecoration(labelText: 'id'),
              ),
              TextField(
                controller: showController,
                decoration: InputDecoration(labelText: 'Show'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Thu thập dữ liệu từ các trường nhập liệu
                    final productData = {
                      'Name': nameController.text,
                      'Price': int.tryParse(priceController.text) ?? 0,
                      'Category': categoryController.text,
                      'Description': descriptionController.text,
                      'ImageUrl': imageUrlController.text,
                      'ImageUrlFacebook': imageUrlFacebookController.text,
                      'Show': int.tryParse(showController.text) ?? 0,
                    };

                    // Gọi hàm thêm sản phẩm với ID người dùng nhập vào
                    final id = idController.text;
                    addProduct(productData, id);

                    // Quay về màn hình trước đó
                  },
                  child: Text('Lưu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
