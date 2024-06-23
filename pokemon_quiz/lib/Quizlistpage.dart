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
      ),
      body: Center(
        child: ListView(
          children: quiz_data
              .map((pokemon) => Column(
                    children: [
                      // カテゴリを追加
                      Image.network(
                          'https://www.google.com/url?sa=i&url=https%3A%2F%2Fanimeanime.jp%2Farticle%2F2018%2F06%2F06%2F38039.html&psig=AOvVaw3PeNIpJsCMI3B-K-nqZmiw&ust=1719019742198000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCJDtztrF64YDFQAAAAAdAAAAABAE'),
                      Text(pokemon.answer),
                      Image.network(pokemon.imgURL),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(pokemon.first),
                          Text(pokemon.second),
                          Text(pokemon.third),
                          Text(pokemon.fourth),
                        ],
                      ),
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
