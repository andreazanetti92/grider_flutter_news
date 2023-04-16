import 'package:flutter/material.dart';

class NewsDetail extends StatelessWidget {
  final int? id;

  const NewsDetail({this.id});

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Story Detail"),
      ),
      body: Text("$id"),
    );
  }
}
