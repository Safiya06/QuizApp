import 'package:flutter/material.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/models/db_connect.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/widgets/next_button.dart';
import 'package:quiz_app/widgets/option_card.dart';
import 'package:quiz_app/widgets/question_widget.dart';
import 'package:quiz_app/widgets/result_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override 
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var db = DBconnect();

  late Future _questions;

  Future<List<QuestionModel>> getData() async {
    return db.fetchQuestions();
  }

  @override
  void initState() {
    _questions = getData();
    super.initState();
  }

  int index = 0;
  int score = 0;
  bool isPressed = false;
  bool isAlredySelected = false;

  void nextQuestion(int questionLength) {
    if (index == questionLength - 1) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => ResultBox(
          result: score,
          questionLength: questionLength,
          onPressed: startOver,
        ));
    } else {
      if (isPressed) {
        setState(() {
          index++;
          isPressed = false;
          isAlredySelected = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Please select any option'),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.symmetric(vertical: 20.0),
          ));
      }
    }
  }

  void checkAnswerAndUpdate(bool value) {
    if (isAlredySelected) {
      return;
    } else {
      if (value == true) {
        score++;
      }
      setState(() {
        isPressed = true;
        isAlredySelected = true;
      });
    }
  }

  void startOver() {
    setState(() {
      index = 0;
      score = 0;
      isPressed = false;
      isAlredySelected = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _questions as Future<List<QuestionModel>>,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if(snapshot.hasError){
            return Center(
            child: Text('${snapshot.error}'),
          );
          } else if (snapshot.hasData) {
          var extractedData = snapshot.data as List<QuestionModel>;
          return Scaffold(
            backgroundColor: background,
            appBar: AppBar(
              title: const Text('Quiz App',
                  style: TextStyle(
                    color: Colors.white,
                  )),
              backgroundColor: background,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    'Score:$score',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            body: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  QuestionWidget(
                    indexAction: index,
                    question: extractedData[index].title,
                    totalQuestions: extractedData.length,
                  ),
                  const Divider(color: natural),
                  const SizedBox(height: 25.0),
                  for (int i = 0; 
                  i < extractedData[index].options.length; 
                  i++)
                    GestureDetector(
                      onTap: () => checkAnswerAndUpdate(
                          extractedData[index].options.values.toList()[i]),
                      child: OptionCard(
                        option: extractedData[index].options.keys.toList()[i],
                        color: isPressed
                            ? extractedData[index]
                            .options
                            .values
                            .toList()[i] ==
                                    true
                                ? correct
                                : incorrect
                            : natural,
                      ),
                    ),
                ],
              ),
            ),
            floatingActionButton: GestureDetector(
              onTap: () => nextQuestion(extractedData.length),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: NextButton(
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
           );
          }
        } else {
          return  Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             const CircularProgressIndicator(),
             const SizedBox(height:20.0),
              Text('Please wait while questions are loading...',
              style:TextStyle(
                color:Theme.of(context).primaryColor,
                decoration: TextDecoration.none,
                fontSize: 14.0,
               ),
              ),
            ],
          ),
          );
        }
        return const Center(
          child: Text('No Data'),
          );
      },
    );
  }
}