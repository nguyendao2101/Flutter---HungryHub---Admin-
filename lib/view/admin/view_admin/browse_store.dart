import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:hungry_hub_web/view_model/home_view_model.dart';

class BrowseStore extends StatefulWidget {
  @override
  _BrowseShopScreenState createState() => _BrowseShopScreenState();
}

class _BrowseShopScreenState extends State<BrowseStore> {
  final controller = Get.put(HomeViewModel());
  final databaseRef = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> browseShopUsers = [];
  List<String> selectedUserIds = [];

  @override
  void initState() {
    super.initState();
    fetchBrowseShopUsers();
  }

  Future<void> fetchBrowseShopUsers() async {
    try {
      final snapshot = await databaseRef.child('browseShop').get();
      if (snapshot.exists && snapshot.value is Map) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          browseShopUsers = data.entries
              .map((entry) => {
            'userId': entry.key,
            ...Map<String, dynamic>.from(entry.value as Map),
          })
              .toList();
        });
      } else {
        setState(() {
          browseShopUsers = [];
        });
        print('Không có dữ liệu trong browseShop');
      }
    } catch (error) {
      print('Lỗi khi lấy dữ liệu: $error');
    }
  }

  Future<void> updateRolesAndRefreshUI() async {
    if (selectedUserIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ít nhất một user để cập nhật!')),
      );
      return;
    }
    try {
      for (final userId in selectedUserIds) {
        await databaseRef.child('users/$userId').update({'role': 'shop'});
        await databaseRef.child('browseShop/$userId').remove();
      }

      setState(() {
        browseShopUsers.removeWhere((user) => selectedUserIds.contains(user['userId']));
        selectedUserIds.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thành công!')),
      );
    } catch (error) {
      print('Lỗi khi cập nhật: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Có lỗi xảy ra khi cập nhật.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 100),
        child: Align(
          alignment: Alignment.topCenter,
          child: Card(
            elevation: 5,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Danh sách tài khoản',
                    style:const TextStyle(
                      fontSize: 24,
                      color: Color(0xff32343E),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 16),
                  browseShopUsers.isEmpty
                      ? const Center(
                    child: Text(
                      'Không có tài khoản nào trong danh sách.',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xff32343E),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  )
                      : DataTable(
                    columns: const [
                      const DataColumn(label: Text('Full Name', style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xff32343E),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),)),
                      const DataColumn(label: Text('Email', style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xff32343E),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),)),
                      const DataColumn(label: Text('Select', style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xff32343E),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),)),
                    ],
                    rows: browseShopUsers
                        .map((user) => DataRow(
                      selected: selectedUserIds.contains(user['userId']),
                      onSelectChanged: (isSelected) {
                        setState(() {
                          if (isSelected == true) {
                            selectedUserIds.add(user['userId']);
                          } else {
                            selectedUserIds.remove(user['userId']);
                          }
                        });
                      },
                      cells: [
                        DataCell(Text(user['fullName'] ?? 'Không có tên')),
                        DataCell(Text(user['email'] ?? 'Không có email')),
                        DataCell(Checkbox(
                          value: selectedUserIds.contains(user['userId']),
                          onChanged: (isChecked) {
                            setState(() {
                              if (isChecked == true) {
                                selectedUserIds.add(user['userId']);
                              } else {
                                selectedUserIds.remove(user['userId']);
                              }
                            });
                          },
                        )),
                      ],
                    ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton.extended(
          onPressed: () {
            if (selectedUserIds.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Vui lòng chọn ít nhất một user để cập nhật!')),
              );
              return;
            }

            // Lặp qua từng userId đã chọn
            for (final userId in selectedUserIds) {
              final user = browseShopUsers.firstWhere(
                    (user) => user['userId'] == userId,
                orElse: () => {},
              );

              if (user.isNotEmpty) {
                final email = user['email'] ?? 'Không có email';
                final fullName = user['fullName'] ?? 'Không có tên';

                // Gọi phương thức sendEmail cho từng người dùng
                controller.sendEmail(email, fullName);
              }
            }

            // Cập nhật UI và dữ liệu
            updateRolesAndRefreshUI();
          },
          icon: const Icon(Icons.update, color: Colors.white),
          label: const Text(
            'Update',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
          backgroundColor: Colors.red,
        ),
      ),

    );
  }
}
