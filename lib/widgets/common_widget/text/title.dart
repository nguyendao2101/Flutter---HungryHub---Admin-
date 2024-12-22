import 'package:flutter/material.dart';

class TitleFood extends StatelessWidget {
  final String text;
  const TitleFood({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(
      fontSize: 20,
      color: Color(0xff32343E),
      fontWeight: FontWeight.w600,
      fontFamily: 'Poppins',
    ),
    );
  }
}
