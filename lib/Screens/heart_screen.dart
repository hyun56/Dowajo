import 'package:flutter/material.dart';

class HeartScreen extends StatefulWidget {
  const HeartScreen({super.key});

  @override
  State<HeartScreen> createState() => _HeartScreen();
}

class _HeartScreen extends State<HeartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('심박수'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text('심박수'),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
    );
  }
}
