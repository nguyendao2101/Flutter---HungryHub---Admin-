import 'package:flutter/material.dart';

class PendingDelivery extends StatefulWidget {
  const PendingDelivery({super.key});

  @override
  State<PendingDelivery> createState() => _PendingDeliveryState();
}

class _PendingDeliveryState extends State<PendingDelivery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Pending delivery'),
      ),
    );
  }
}
