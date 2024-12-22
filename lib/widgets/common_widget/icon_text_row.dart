import 'package:flutter/material.dart';

class IconTextRow extends StatelessWidget {
  final String title;

  final VoidCallback onTap;
  const IconTextRow({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 40,
          child: ListTile(
            title: Text(
              title,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins'
              ),
            ),
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}
