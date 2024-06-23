import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

class Quiz_data {
  final String answer;
  final String first;
  final String second;
  final String third;
  final String fourth;
  final String imgURL;
  final int quiz_id;

  Quiz_data(
      {required this.answer,
      required this.first,
      required this.second,
      required this.third,
      required this.fourth,
      required this.imgURL,
      required this.quiz_id});

  factory Quiz_data.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Quiz_data(
        answer: data['answer'],
        first: data['first'],
        second: data['second'],
        third: data['third'],
        fourth: data['fourth'],
        quiz_id: data['quiz_id'],
        imgURL: data['imgURL']);
  }
}
