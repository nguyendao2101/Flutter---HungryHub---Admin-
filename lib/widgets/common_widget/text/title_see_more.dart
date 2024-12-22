import 'package:flutter/material.dart';

class TitleSeeMore extends StatelessWidget {
  final String title;
  const TitleSeeMore({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(
            fontSize: 16,
            color: Color(0xff32343E),
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),),
          const Text('See all', style: TextStyle(
            fontSize: 16,
            color: Color(0xffF44336),
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
          ),)
        ],
      ),
    );
  }
}
