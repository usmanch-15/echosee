import 'package:flutter/material.dart';

class AccountsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accounts'),
      ),
      body: Center(
        child: Text(
          'Accounts Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}