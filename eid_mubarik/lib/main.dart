import 'package:eid_mubarik/eid.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eid Mubarak',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Scheherazade', // Islamic style font
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Scheherazade'),
          bodyLarge: TextStyle(fontFamily: 'Scheherazade'),
          titleLarge: TextStyle(fontFamily: 'Scheherazade'),
        ),
      ),
      home: const EidMubarak(),
    );
  }
}


