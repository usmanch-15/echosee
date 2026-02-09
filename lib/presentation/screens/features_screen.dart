import 'package:flutter/material.dart';

class FeaturesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Features'),
      ),
      body: Center(
        child: Text(
          'Features Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}