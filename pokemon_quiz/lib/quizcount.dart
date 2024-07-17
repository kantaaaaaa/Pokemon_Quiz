import 'package:cloud_firestore/cloud_firestore.dart';

import 'Pokemondata.dart';

Future<int?> addfirebase_method() async {
  // Firestoreインスタンスを取得
  final db = FirebaseFirestore.instance;
  final snapshot = await db.collection('Quizdata').count().get();
  final usersLength = snapshot.count;
  return usersLength;
}

Future<List<Quiz_data>> input_quizdata(
  List<int> search_arr,
) async {
  List<Quiz_data> quiz_data = [];
  final db = FirebaseFirestore.instance;

  for (var element in search_arr) {
    final event = await db
        .collection('Quizdata')
        //.orderBy('quiz_id', descending: false)
        //.where('answer', isEqualTo: searchword)
        .where('quiz_id', isEqualTo: element)
        .get();
    final docs = event.docs;
    final pokemon = docs.map((doc) => Quiz_data.fromFirestore(doc)).toList();
    quiz_data += pokemon;
    print(quiz_data);
  }
  return quiz_data;
}
