import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

class Favorite_data {
  final String uid;
  final int quiz_id;

  Favorite_data({required this.uid, required this.quiz_id});

  factory Favorite_data.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Favorite_data(
      uid: data['uid'],
      quiz_id: data['quiz_id'],
    );
  }
}
