import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:humphreys/firebase_options.dart'; // for DefaultFirebaseOptions.currentPlatform
import 'package:humphreys/under_main/body.dart';
import 'package:humphreys/under_main/appbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Pretendard'),
      home: SafeArea(
        child: Scaffold(
          body: Stack( // 마지막에 생성된 위젯이 가장 위로 옴.
            children: [
              Positioned.fill(
                child: Body(),
              ),
              Positioned(
                top: 10,
                left: 10,
                right: 10,
                child: Appbar(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}