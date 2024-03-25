import 'package:http/http.dart' as http;
import 'package:quiz_app/models/question_model.dart';
import 'dart:convert';

class DBconnect{
  final url = Uri.parse(
    'https://simplequizapp-9eb9a-default-rtdb.firebaseio.com/questions.json');

  Future<List<QuestionModel>> fetchQuestions() async{
    return http.get(url).then((response){
      var data = json.decode(response.body) as Map<String,dynamic>;
     List<QuestionModel> newQuestions =[];
      data.forEach((key,value){
        var newQuestion = QuestionModel(
          id: key,
          title: value['title'],
          options: Map.castFrom(value['options']),
        );
        newQuestions.add(newQuestion);
      });
     return newQuestions;
    });
  }
  
}