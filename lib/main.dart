import 'package:flutter/material.dart';
import 'package:multi_slot_labelling_machine/screens/machineScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MachineScreen(title:"Create A Machine")
    );
  }
}