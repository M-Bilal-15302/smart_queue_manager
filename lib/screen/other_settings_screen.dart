import 'package:flutter/material.dart';

class OtherSettingsPage extends StatelessWidget {
  const OtherSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Other Settings"),
      ),
      body: Center(
        child: Text('This is the Other Settings Page'),
      ),
    );
  }
}
