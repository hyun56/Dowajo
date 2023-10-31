import 'package:flutter/material.dart';

class MacroScreen extends StatefulWidget {
  const MacroScreen({super.key});

  @override
  State<MacroScreen> createState() => _MacroScreen();
}

class _MacroScreen extends State<MacroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('매크로 설정'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text('매크로 설정'),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
    );
  }
}
