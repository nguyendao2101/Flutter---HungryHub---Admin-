import 'package:flutter/material.dart';

class BrowseStore extends StatefulWidget {
  const BrowseStore({super.key});

  @override
  State<BrowseStore> createState() => _BrowseStoreState();
}

class _BrowseStoreState extends State<BrowseStore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Browse Store'),
      ),
    );
  }
}
