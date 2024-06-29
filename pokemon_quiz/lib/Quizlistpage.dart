import 'dart:html';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokemon_quiz/Pokemondata.dart';
import 'dart:async';

import 'Quiz_add.dart';
import 'Quizpage.dart';

class QuziListtPage extends StatefulWidget {
  const QuziListtPage({Key? key}) : super(key: key);

  @override
  _QuziListtPage createState() => _QuziListtPage();
}

class _QuziListtPage extends State<QuziListtPage> {
  List<Quiz_data> quiz_data = [];
  List<int> favorite_view = [];
  final quizdb_index = 0;

  @override
  void initState() {
    super.initState();

    _viewfirebase();
  }

  void _viewfirebase() async {
    final db = FirebaseFirestore.instance;

    final event = await db
        .collection('Quizdata')
        .orderBy('quiz_id', descending: false)
        .get();
    //final event = await db.collection("Quizdata").get();
    final docs = event.docs;
    final pokemon = docs.map((doc) => Quiz_data.fromFirestore(doc)).toList();

    setState(() {
      this.quiz_data = pokemon;
      favorite_view = List.filled(quiz_data.length, 0);
      // print(favorite_view[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('4択クイズ'),
      ),
      resizeToAvoidBottomInset: false,
      body: GridView.builder(
        itemCount: quiz_data.length,
        itemBuilder: (context, index) {
          // favorite_view.add(0);
          print(favorite_view[index]);
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
                          // if (favorite_view[index] == 0)
                          //   // ハートアイコン
                          //   favorite_heart()
                          // else
                          //   Text("うわあああああああああああああああ")
                          favorite_heart(index: index),
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Quiz_add()),
          );
        },
        label: const Text('クイズ追加'),
        icon: const Icon(Icons.thumb_up),
        backgroundColor: Colors.pink,
      ),
    );
  }
}

class favorite_heart extends StatefulWidget {
  const favorite_heart({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  State<favorite_heart> createState() => _FavoriteHeartState(index: index);
}

class _FavoriteHeartState extends State<favorite_heart> {
  _FavoriteHeartState({required this.index});
  int index;
  // int favorite_index = index + 1;

  Color _iconColor = Colors.white;
  void _toggleColor(int input_index) {
    setState(() {
      print(input_index);
      _iconColor = _iconColor == Colors.white ? Colors.red : Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      right: 16,
      child: IconButton(
        icon: Icon(
          Icons.favorite_outline,
          color: _iconColor, // アイコンカラーにステート変数を使用
        ),
        iconSize: 28,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(), // アイコンボタンの余白を0にするため記述
        onPressed: () {
          _toggleColor(index + 1);
          // print(index + 1);
        },
      ),
    );
  }
}
