import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:websocket_usage/home_page.dart';

void main(){
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

