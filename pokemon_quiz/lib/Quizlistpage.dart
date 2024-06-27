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
  String firebaseText = '';
  List<Quiz_data> quiz_data = [];

  @override
  void initState() {
    super.initState();

    _viewfirebase();
  }

  void _viewfirebase() async {
    final db = FirebaseFirestore.instance;

    final event = await db.collection("Quizdata").get();
    final docs = event.docs;
    final pokemon = docs.map((doc) => Quiz_data.fromFirestore(doc)).toList();

    setState(() {
      this.quiz_data = pokemon;
      print(pokemon);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        title: Text("クイズ一覧ページ"),
      ),
      body: Center(
        child: ListView(
          children: quiz_data
              .map((pokemon) => Column(
                    children: [
                      Card(
                        elevation: 4,
                        margin: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer, // 画像を丸角にする
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                if (pokemon.imgURL == "")
                                  Image.network(
                                    "images/path.png",
                                    width: 100,
                                    height: 100,
                                  )
                                else
                                  Image.network(
                                    pokemon.imgURL,
                                    width: 100,
                                    height: 100,
                                  ),
                                // ハートアイコン
                                Positioned(
                                  top: 16,
                                  right: 16,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.favorite_outline,
                                      color: Colors.white,
                                    ),
                                    iconSize: 28,
                                    padding: EdgeInsets.zero,
                                    constraints:
                                        const BoxConstraints(), // アイコンボタンの余白を0にするため記述
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                            // タイトル
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              child: Text(
                                pokemon.answer,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            // 説明文
                            Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                pokemon.first +
                                    pokemon.second +
                                    pokemon.third +
                                    pokemon.fourth,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // カテゴリを追加
                      // Image.network(
                      //     "https://i.pinimg.com/736x/5d/6d/23/5d6d23fd7adb44baba20a60c252da339.jpg"),
                      // Text(pokemon.answer),
                      // if (pokemon.imgURL == "")
                      //   Image.network(
                      //     "images/path.png",
                      //     width: 100,
                      //     height: 100,
                      //   )
                      // else
                      //   Image.network(
                      //     pokemon.imgURL,
                      //     width: 100,
                      //     height: 100,
                      //   ),

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text(pokemon.first),
                      //     SizedBox(
                      //       width: 20,
                      //     ),
                      //     Text(pokemon.second),
                      //     SizedBox(
                      //       width: 20,
                      //     ),
                      //     Text(pokemon.third),
                      //     SizedBox(
                      //       width: 20,
                      //     ),
                      //     Text(pokemon.fourth),
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 70,
                      // )
                    ],
                  ))
              .toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _gotoAddPage();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _gotoAddPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Quiz_add()),
    );
  }
}
