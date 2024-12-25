import 'package:flutter/material.dart';

class QuarterView extends StatefulWidget {
  const QuarterView({super.key});

  @override
  State<QuarterView> createState() => _QuarterViewState();
}

class _QuarterViewState extends State<QuarterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Quarter '),
      ),
    );
  }
}
