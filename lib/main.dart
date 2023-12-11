import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orc/home.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Image to Ttext Converter GetX',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}


/* Platform  Firebase App Id
android   1:177705021272:android:4baa86e33527a8141a7f2d
ios       1:177705021272:ios:58bad8a06aeaa6be1a7f2d */