import 'package:flutter/material.dart';

class StoreManagementView extends StatefulWidget {
  const StoreManagementView({super.key});

  @override
  State<StoreManagementView> createState() => _StoreManagementViewState();
}

class _StoreManagementViewState extends State<StoreManagementView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Store management'),
      ),
    );
  }
}
