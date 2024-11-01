import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyLoginSocialButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String imagePath;
  final String buttonText;
  final Color backgroundColor;
  final Color textColor;

  const MyLoginSocialButton({
    super.key,
    required this.onPressed,
    required this.imagePath,
    required this.buttonText,
    this.backgroundColor = Colors.transparent, // 기본값 투명
    this.textColor = Colors.black, // 기본값 검정색
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            imagePath,
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 10),
          Text(
            buttonText,
            style: TextStyle(fontSize: 14, color: textColor),
          ),
        ],
      ),
    );
  }
}
