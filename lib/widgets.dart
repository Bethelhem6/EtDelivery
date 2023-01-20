// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class RichTextWidget extends StatelessWidget {
  String text1;
  String text2;
  RichTextWidget({
    Key? key,
    required this.text1,
    required this.text2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: text1,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          TextSpan(
            text: text2,
            style: const TextStyle(
              overflow: TextOverflow.ellipsis,
              color: Colors.grey,
              fontWeight: FontWeight.normal,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
