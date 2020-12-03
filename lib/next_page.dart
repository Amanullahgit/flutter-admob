import 'package:flutter/material.dart';

class NextPage extends StatefulWidget {
  final coins;
  NextPage({this.coins});
  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coins: ${widget.coins}'),
      ),
    );
  }
}
