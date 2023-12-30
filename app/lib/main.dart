import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared/shared_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                _value = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_value == null) {
                return;
              }
              final model = SharedModel(value: _value!);
              http.post(
                //Uri.parse('http://localhost:8080/model'),
                Uri.parse('https://dart-fullstack-monorepo-om8hwyn-robiness.globeapp.dev/model'),
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode(model.toJson()),
              );
            },
            child: const Text('Send SharedModel'),
          ),
        ],
      ),
    );
  }
}
