import 'package:flutter/material.dart';
import 'package:frontend/Screens/qr_generator.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'Database/database.dart';
import 'Screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3:  true,
        primarySwatch: Colors.blue,
      ),
      home: (Platform.isAndroid) ?
      ChangeNotifierProvider(
          create: (context) => Data() ,
          child: HomeScreen()
      )
          : Scaffold(backgroundColor: Color(0xff252525),),
    );
  }
}