import 'package:flutter/material.dart';
import 'package:quiz_app/constants.dart';

class ResultBox extends StatelessWidget {
  const ResultBox({
      super.key, 
      required this.result, 
      required this.questionLength, 
      required this.onPressed
      });
  final int result;
  final int questionLength;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: background,
      content: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Result',
              style: TextStyle(
                color: natural,
                fontSize: 22.0,
              ),
            ),
            const SizedBox(height: 20.0),
            CircleAvatar(
              radius: 70.0,
              backgroundColor: result == questionLength / 2
                    ? Colors.yellow
                    : result < questionLength / 2
                        ? incorrect
                        : correct,
              child: Text(
                '$result/$questionLength',
                style: const TextStyle(fontSize: 30.0,color:natural),
              )
            ),
            const SizedBox(height:20.0),
            Text(result == questionLength / 2
                  ? 'Almost There'
                  : result < questionLength / 2
                      ? 'Try Again ?' 
                          : 'Great!',
                          style: const TextStyle(color: natural,),
                ),
                const SizedBox(height:22.0),
                GestureDetector(
                  onTap:onPressed,
                  child:const Text(
                    'Start Over',
                    style: TextStyle(
                      color:Colors.blue,
                      fontSize:20.0,
                      letterSpacing:1.0,
                    ),
                  )
                )
          ],
        ),
      ),
    );
  }
}
