import 'dart:html';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokemon_quiz/Favoritedata.dart';
import 'package:pokemon_quiz/Pokemondata.dart';
import 'dart:async';

import 'Quiz_add.dart';
import 'Quizpage.dart';

class Favorite_quiz_Page extends StatefulWidget {
  const Favorite_quiz_Page({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  _Favorite_quiz_Page createState() => _Favorite_quiz_Page(uid: uid);
}

List<int> favorite_view = [];

class _Favorite_quiz_Page extends State<Favorite_quiz_Page> {
  _Favorite_quiz_Page({required this.uid});
  List<Quiz_data> quiz_data = [];
  List<Favorite_data> favorite_data = [];
  List<Quiz_data> favorite_quizdata = [];

  final quizdb_index = 0;
  String uid;

  @override
  void initState() {
    super.initState();
    print(uid);

    _viewfirebase();
  }

  void _viewfirebase() async {
    final db = FirebaseFirestore.instance;

    final favorite_event = await db
        .collection('Favoritedata')
        //.orderBy('quiz_id', descending: false)
        .where('uid', isEqualTo: uid)
        .get();
    final favorite_docs = favorite_event.docs;
    final favorite_data =
        favorite_docs.map((doc) => Favorite_data.fromFirestore(doc)).toList();
    this.favorite_data = favorite_data;

    final quiz_id = favorite_data.map((favData) => favData.quiz_id).toList();

    quiz_id.sort();

    for (var element in quiz_id) {
      final event = await db
          .collection('Quizdata')
          //.orderBy('quiz_id', descending: false)
          .where('quiz_id', isEqualTo: element)
          .get();
      final docs = event.docs;
      final pokemon = docs.map((doc) => Quiz_data.fromFirestore(doc)).toList();
      this.quiz_data += pokemon;

      print(element);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('お気に入り一覧'),
        ),
        resizeToAvoidBottomInset: false,
        body: GridView.builder(
          itemCount: quiz_data.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                SizedBox(
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer, // 画像を丸角にする
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            if (quiz_data[index].imgURL == "")
                              Image.network(
                                "images/path.png",
                                width: 1000,
                                height: 120,
                              )
                            else
                              Image.network(
                                quiz_data[index].imgURL,
                                width: 1000,
                                height: 120,
                              ),
                          ],
                        ),
                        // タイトル
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          child: Text(
                            "正解名   " + quiz_data[index].answer,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        // 説明文
                        Container(
                          child: Column(
                            children: [
                              Text(
                                "1." +
                                    quiz_data[index].first +
                                    "    2." +
                                    quiz_data[index].second,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "3." +
                                    quiz_data[index].third +
                                    "    4." +
                                    quiz_data[index].fourth,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  width: 350,
                  height: 230,
                ),
              ],
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            childAspectRatio: 1.5,
          ),
        ));
  }
}
