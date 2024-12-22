import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MainNavShop extends StatefulWidget {
  const MainNavShop({super.key});

  @override
  State<MainNavShop> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MainNavShop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('main nav shop'),
      ),
    );
  }
}
