import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MainNavAdmin extends StatefulWidget {
  const MainNavAdmin({super.key});

  @override
  State<MainNavAdmin> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MainNavAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text('main nav navigator'),
          ),
          Center(
            child: Text('main nav navigator'),
          ),
          Center(
            child: Text('main nav navigator'),
          ),
        ],
      ),
    );
  }
}
