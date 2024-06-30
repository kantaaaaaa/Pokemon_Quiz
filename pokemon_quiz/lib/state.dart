import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

// ログインユーザーのUIDを保持するProvider
final userUIDProvider = StateProvider<String?>(null!);
