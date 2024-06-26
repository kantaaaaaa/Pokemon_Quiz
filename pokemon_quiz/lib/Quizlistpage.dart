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
                      // カテゴリを追加
                      // Image.network(
                      //     "https://i.pinimg.com/736x/5d/6d/23/5d6d23fd7adb44baba20a60c252da339.jpg"),
                      Text(pokemon.answer),
                      Image.network(
                        pokemon.imgURL,
                        width: 100,
                        height: 100,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(pokemon.first),
                          SizedBox(
                            width: 20,
                          ),
                          Text(pokemon.second),
                          SizedBox(
                            width: 20,
                          ),
                          Text(pokemon.third),
                          SizedBox(
                            width: 20,
                          ),
                          Text(pokemon.fourth),
                        ],
                      ),
                      const SizedBox(
                        height: 70,
                      )
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
