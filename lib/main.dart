import 'package:flutter/material.dart';
import 'screens/toko_komputer_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Komputer',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TokoKomputerScreen(),
    );
  }
}
