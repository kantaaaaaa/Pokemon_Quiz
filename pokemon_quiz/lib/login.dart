import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';

import 'Pokemondata.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _login();
}

class _login extends State<login> {
  // ログインID
  String LoginEmail = "";
  // パスワード
  String LoginPassword = "";
  // ログインメッセージ
  String LoginMessage = "Not Login";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('ログイン'),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // メールアドレス入力欄
              TextFormField(
                decoration: InputDecoration(labelText: "メールアドレス"),
                onChanged: (String inputValue) {
                  // 値が変更された際に入力内容を変数に保持
                  setState(() {
                    LoginEmail = inputValue;
                  });
                },
              ),
              // パスワード入力欄
              TextFormField(
                decoration: InputDecoration(labelText: "パスワード"),
                obscureText: true,
                onChanged: (String inputValue) {
                  // 値が変更された際に入力内容を変数に保持
                  setState(() {
                    LoginPassword = inputValue;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // Firebase認証処理
                    final UserCredential result = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: LoginEmail, password: LoginPassword);
                    // ログイン成功時にはユーザーを取得
                    final User user = result.user!;
                    final String uid = user.uid;
                    setState(() {
                      LoginMessage = "ハッピーハッピーハッピー - ${uid}";
                    });
                  } catch (e) {
                    // ログイン失敗時
                    setState(() {
                      LoginMessage = "失敗いいいいいいいいいいい - ${e.toString()}";
                    });
                  }
                },
                child: Text("Auth"),
              ),
              Text(LoginMessage)
            ],
          ),
        ),
      ),
    );
  }
}
