import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'Favoritedata.dart';
import 'Pokemondata.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  _MyWidgetState createState() => _MyWidgetState(uid: uid);
}

List<int> favorite_view = [];

class _MyWidgetState extends State<SearchWidget> {
  String view_text = "aaaaaaaaaaaaaa";
  _MyWidgetState({required this.uid});
  List<Quiz_data> quiz_data = [];
  List<Quiz_data> quiz_data2 = [];
  List<Favorite_data> favorite_data = [];

  List<String> answer_arr = [];
  List<int> search_arr = [];

  final quizdb_index = 0;
  String uid;

  @override
  void initState() {
    super.initState();
    print(uid);

    _viewfirebase();
  }

  //ページを開いた一度だけ実行する。クイズ全部を表示する。
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

    for (var i = 0; i < quiz_data.length; i++) {
      answer_arr.add(quiz_data[i].answer);

      print(answer_arr[i]);
    }

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

  //検索エンジンが何も入力されていないときだけ実行される。クイズ全部を表示する。
  void _viewfirebase2() async {
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

  //クイズの正解名と入力された文字列を照らし合わせ、一致した文字列のindex番号をリストに入れる
  void _searchresult(String word) {
    //print(word);
    search_arr.clear();
    //print(search_arr);
    int i = 0;
    for (i = i; i < answer_arr.length; i++) {
      if (answer_arr[i].contains(word)) {
        search_arr.add(i + 1);
        //print(search_arr[i]);
        //print(i);
      }
      //print(i);
    }
    //print(search_arr);
  }

  //_searchresultでリストに入れた検索結果をデータベースから取得する
  void _searchdata() async {
    //print(searchword);
    final db = FirebaseFirestore.instance;
    quiz_data.clear();
    //print(quiz_data);

    for (var element in search_arr) {
      final event = await db
          .collection('Quizdata')
          //.orderBy('quiz_id', descending: false)
          //.where('answer', isEqualTo: searchword)
          .where('quiz_id', isEqualTo: element)
          .get();
      final docs = event.docs;
      final pokemon = docs.map((doc) => Quiz_data.fromFirestore(doc)).toList();
      this.quiz_data += pokemon;
      //print(quiz_data);
    }

    favorite_view = List.filled(quiz_data.length, 0);
    print(search_arr);

    favorite_data.clear();
    for (var element in search_arr) {
      print(element);
      final favorite_event = await db
          .collection('Favoritedata')
          .where('uid', isEqualTo: uid)
          .where('quiz_id', isEqualTo: element)
          .get();
      final favorite_docs = favorite_event.docs;
      final favorite =
          favorite_docs.map((doc) => Favorite_data.fromFirestore(doc)).toList();
      this.favorite_data += favorite;
    }
    print(favorite_data);

    for (var element in favorite_data) {
      favorite_view[element.quiz_id - 1]++;
    }

    print(favorite_view);

    setState(() {});
  }

  //ひらがなをカタカナにする
  _hiraganaToKatakana(val) {
    return val.replaceAllMapped(RegExp("[ぁ-ゔ]"),
        (Match m) => String.fromCharCode(m.group(0)!.codeUnitAt(0) + 0x60));
  }

  //引数で受け取った文字列に英語が含まれていたら、falseを返す。
  bool containJapanese(String text) {
    // 半角英数字の正規表現
    RegExp halfWidthEnglishRegExp = RegExp(r'[a-zA-Z]');

    // 全角英数字の正規表現
    RegExp fullWidthEnglishRegExp = RegExp(r'[Ａ-Ｚａ-ｚ]');

    // 引数に半角英数字と全角英数字が両方含まれているかチェック
    bool hasMixedWidthEnglish = halfWidthEnglishRegExp.hasMatch(text) ||
        fullWidthEnglishRegExp.hasMatch(text);

    return !hasMixedWidthEnglish;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('問題一覧ページ'),
        actions: [
          SizedBox(
            width: 600,
            child: TextField(
              onChanged: (text) {
                print('First text field: $text');
                setState(() {
                  if (text == "") {
                    _viewfirebase2();
                  } else {
                    text = _hiraganaToKatakana(text);
                    print(containJapanese(text));
                    if (containJapanese(text)) {
                      _searchresult(text);
                      _searchdata();
                    }
                  }
                });
              },
            ),
          ),
          const SizedBox(
            width: 170,
          ),
          Text(view_text),
          const SizedBox(
            width: 70,
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: GridView.builder(
        itemCount: quiz_data.length,
        itemBuilder: (context, index) {
          // favorite_view.add(0);
          //print(favorite_view[index]);
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
