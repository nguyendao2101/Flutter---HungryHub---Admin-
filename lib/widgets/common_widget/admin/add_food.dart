import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hungry_hub_web/widgets/common_widget/button/bassic_button.dart';

class AddFood extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers for input fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController imageUrlFacebookController = TextEditingController();
  final TextEditingController showController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  // Selected category
  String selectedCategory = 'Combo 1 Người';

  // List of categories
  final List<String> categories = [
    'Combo 1 Người',
    'Combo Nhóm',
    'Gà Rán - Gà Quay',
    'Burger - Cơm - Mì Ý',
    'Thức ăn nhẹ',
    'Thức uống & tráng miệng',
  ];

  // Function to add product to Firestore
  Future<void> addProduct(Map<String, dynamic> productData, String id) async {
    try {
      await _firestore.collection('products').doc(id).set(productData);
      print('Product with ID $id added successfully.');
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  // Function to reset input fields
  void resetFields() {
    nameController.clear();
    priceController.clear();
    descriptionController.clear();
    imageUrlController.clear();
    imageUrlFacebookController.clear();
    showController.clear();
    idController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Product Details',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    // Input Fields
                    buildTextField(controller: nameController, label: 'Name'),
                    buildTextField(controller: priceController, label: 'Price', inputType: TextInputType.number),

                    // Dropdown for category
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: DropdownButtonFormField<String>(
                        value: selectedCategory,
                        items: categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            selectedCategory = value;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),

                    buildTextField(controller: descriptionController, label: 'Description'),
                    buildTextField(controller: imageUrlController, label: 'Image URL'),
                    buildTextField(controller: imageUrlFacebookController, label: 'Image URL Facebook'),
                    buildTextField(controller: idController, label: 'ID'),
                    buildTextField(controller: showController, label: 'Show', inputType: TextInputType.number),

                    const SizedBox(height: 20),

                    // Save Button
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: BasicAppButton(
                          onPressed: () {
                            final productData = {
                              'Name': nameController.text,
                              'Price': int.tryParse(priceController.text) ?? 0,
                              'Category': selectedCategory,
                              'Description': descriptionController.text,
                              'ImageUrl': imageUrlController.text,
                              'ImageUrlFacebook': imageUrlFacebookController.text,
                              'Show': int.tryParse(showController.text) ?? 0,
                              'id': idController.text,
                            };
                            final id = idController.text;
                            addProduct(productData, id);
                            resetFields();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Product added successfully!')),
                            );
                          },
                          title: 'Save',
                          sizeTitle: 16,
                          colorButton: const Color(0xffFB4141),
                          radius: 8,
                          fontW: FontWeight.w500,
                          height: 50,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Preview',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 400,
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ValueListenableBuilder(
                      valueListenable: imageUrlFacebookController,
                      builder: (context, value, child) {
                        return imageUrlFacebookController.text.isEmpty
                            ? const Center(child: Text('No Image'))
                            : Image.network(
                          imageUrlFacebookController.text,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image)),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build text fields
  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType inputType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        keyboardType: inputType,
      ),
    );
  }
}
