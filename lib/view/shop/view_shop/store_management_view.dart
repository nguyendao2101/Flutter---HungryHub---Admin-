import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry_hub_web/view_model/home_view_model.dart';
import 'package:hungry_hub_web/view_model/shop/main_nav_view_model.dart';
import '../../../widgets/common_widget/button/bassic_button.dart';

class StoreManagementView extends StatefulWidget {
  @override
  _StoreManagementViewState createState() => _StoreManagementViewState();
}

class _StoreManagementViewState extends State<StoreManagementView> {
  final controller = Get.put(HomeViewModel());
  final controllerMainNavShop = Get.put(MainNavShopViewModel());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController wardsController = TextEditingController();

  final List<Map<String, dynamic>> listProducts = [];
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchShopData();
  }

  Future<void> fetchShopData() async {
    try {
      final doc = await _firestore.collection('stores').doc(controllerMainNavShop.userId).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          setState(() {
            nameController.text = data['Name'] ?? '';
            addressController.text = data['Address'] ?? '';
            latitudeController.text = data['Latitude'] ?? '';
            longitudeController.text = data['Longitude'] ?? '';
            phoneNumberController.text = data['PhoneNumber'] ?? '';
            wardsController.text = data['Wards'] ?? '';
            listProducts.clear();
            if (data['ListProducts'] is List) {
              listProducts.addAll(List<Map<String, dynamic>>.from(data['ListProducts']));
            }
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải dữ liệu cửa hàng: $e')),
      );
    }
  }
  Future<void> addInfomationShop(Map<String, dynamic> storeData, String id) async {
    try {
      // Lưu thông tin cửa hàng vào Firestore
      await _firestore.collection('stores').doc(id).set(storeData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Success! Store and product information has been successfully added!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Row(
            children: [
              Expanded(flex: 1, child: Container()),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(nameController, 'Store Name', 'Vui lòng nhập tên cửa hàng'),
                    _buildTextField(addressController, 'Addresss', 'Vui lòng nhập địa chỉ'),
                    _buildTextField(latitudeController, 'Latitude', 'Vui lòng nhập vĩ độ', keyboardType: TextInputType.number),
                    _buildTextField(longitudeController, 'Longitude', 'Vui lòng nhập kinh độ', keyboardType: TextInputType.number),
                    _buildTextField(phoneNumberController, 'Phone Number', 'Vui lòng nhập số điện thoại'),
                    _buildTextField(wardsController, 'Wards ', 'Vui lòng nhập phường'),

                    const SizedBox(height: 20),
                    const Text(
                      'Product List',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: listProducts.length,
                      itemBuilder: (context, index) {
                        final product = listProducts[index];
                        return ListTile(
                          title: Text('${product['name']}'),
                          subtitle: Text('Giá: ${product['price']}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => removeProductFromList(index),
                          ),
                        );
                      },
                    ),
                    _buildTextField(productNameController, 'Product Name', 'Vui lòng nhập tên sản phẩm'),
                    _buildTextField(productPriceController, 'Product Price', 'Vui lòng nhập giá sản phẩm', keyboardType: TextInputType.number),
                    // ElevatedButton(
                    //   onPressed: addProductToList,
                    //   child: const Text('Add Product'),
                    // ),
                    SizedBox(
                      width: 160,
                      child: BasicAppButton(
                        onPressed: addProductToList,
                        title: 'Add Product',
                        sizeTitle: 12,
                        colorButton: const Color(0xff4C585B),
                        radius: 8,
                        fontW: FontWeight.w500,
                        height: 50,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: BasicAppButton(
                          onPressed: () {
                            if (nameController.text.isNotEmpty && addressController.text.isNotEmpty) {
                              final storeData = {
                                'Name': nameController.text,
                                'Address': addressController.text,
                                'Latitude': latitudeController.text,
                                'Longitude': longitudeController.text,
                                'PhoneNumber': phoneNumberController.text,
                                'Wards': wardsController.text,
                                'ListProducts': listProducts,
                              };
                              addInfomationShop(storeData, controllerMainNavShop.userId);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Error! Please enter complete store information')),
                              );
                            }
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
              Expanded(flex: 1, child: Container()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String errorMessage,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
      ),
    );
  }

  void removeProductFromList(int index) {
    setState(() {
      listProducts.removeAt(index);
    });
  }

  void addProductToList() {
    if (productNameController.text.isNotEmpty && productPriceController.text.isNotEmpty) {
      setState(() {
        listProducts.add({
          'name': productNameController.text,
          'stock': double.tryParse(productPriceController.text) ?? 0,
        });
      });
      productNameController.clear();
      productPriceController.clear();
    }
  }
}
