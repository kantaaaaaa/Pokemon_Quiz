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

class QuizListtPage extends StatefulWidget {
  const QuizListtPage({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  _QuizListtPage createState() => _QuizListtPage(uid: uid);
}

List<int> favorite_view = [];

class _QuizListtPage extends State<QuizListtPage> {
  _QuizListtPage({required this.uid});
  List<Quiz_data> quiz_data = [];
  List<Favorite_data> favorite_data = [];

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

    final event = await db
        .collection('Quizdata')
        .orderBy('quiz_id', descending: false)
        .get();
    final docs = event.docs;
    final pokemon = docs.map((doc) => Quiz_data.fromFirestore(doc)).toList();
    this.quiz_data = pokemon;
    //print(quiz_data[0].answer);
    favorite_view = List.filled(quiz_data.length, 0);

    final favorite_event =
        await db.collection('Favoritedata').where('uid', isEqualTo: uid).get();
    final favorite_docs = favorite_event.docs;
    final favorite =
        favorite_docs.map((doc) => Favorite_data.fromFirestore(doc)).toList();
    this.favorite_data = favorite;

    for (var element in favorite_data) {
      favorite_view[element.quiz_id - 1]++;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('問題一覧ページ'),
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
                          favorite_heart(
                            index: index,
                            uid: uid,
                            favorite_decision: 0,
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
  const favorite_heart(
      {Key? key,
      required this.index,
      required this.uid,
      required this.favorite_decision})
      : super(key: key);
  final int index;
  final String uid;
  final int favorite_decision;

  @override
  State<favorite_heart> createState() => _FavoriteHeartState(
      index: index, uid: uid, favorite_decision: favorite_decision);
}

class _FavoriteHeartState extends State<favorite_heart> {
  _FavoriteHeartState(
      {required this.index,
      required this.uid,
      required this.favorite_decision});
  int index;
  String uid;
  int favorite_decision;
  // int favorite_index = index + 1;

  int _iconColor = 0;
  Future<void> _favoriteadd(int input_index) async {
    final db = FirebaseFirestore.instance;
    final Favorite_data = <String, dynamic>{
      "quiz_id": input_index,
      "uid": uid,
    };

    await db.collection("Favoritedata").add(Favorite_data);
  }

  Future<void> _favoritedel(int input_index) async {
    final db = FirebaseFirestore.instance;

    // Favoritedataコレクションへの参照を取得
    final quizzesRef = db.collection('Favoritedata');

    // quiz_idが一致するドキュメントを検索するためのクエリを作成
    final query = quizzesRef.where('quiz_id', isEqualTo: input_index);

    // クエリを実行して一致するドキュメントを取得
    final querySnapshot = await query.get();

    // ドキュメントが見つかったかどうかを確認
    if (querySnapshot.docs.isNotEmpty) {
      // 一致するquiz_idのドキュメント参照を取得
      final docRef = querySnapshot.docs.first.reference;

      // ドキュメントを削除
      await docRef.delete();
    }
  }

  Future<void> _toggleColor(int input_index, int index) async {
    if (favorite_view[index] == 0)
      _favoriteadd(input_index);
    else
      _favoritedel(input_index);

    setState(() {
      favorite_view[index] =
          favorite_view[index] == 0 ? _iconColor = 1 : _iconColor = 0;

      print(favorite_view[0]);
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
          color: favorite_view[index] == 0 ? Colors.white : Colors.red,
        ),
        iconSize: 28,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(), // アイコンボタンの余白を0にするため記述
        onPressed: () {
          _toggleColor(index + 1, index);
          // print(index + 1);
        },
      ),
    );
  }
}
