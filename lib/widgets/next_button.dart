import 'package:flutter/material.dart';
import 'package:quiz_app/constants.dart';

class NextButton extends StatelessWidget {
  const NextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:double.infinity,
      decoration:BoxDecoration(
        color:natural,
        borderRadius: BorderRadius.circular(10),
      ),
      padding:const EdgeInsets.symmetric(vertical:16.0),
      child: const Text(
        'Next Question',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0 ,
        ),
      ),
    );
  }
}