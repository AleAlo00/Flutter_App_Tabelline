import 'package:flutter/material.dart';
import 'widgets/main_menu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tabelline',
      debugShowCheckedModeBanner: false,  // Nasconde il banner di debug
      theme: ThemeData(
        // Imposta sfondo bianco e oggetti blu scuro
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.blue[900], // Blu scuro
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[900], // Colore AppBar blu scuro
        ),
        iconTheme: IconThemeData(
          color: Colors.blue[900], // Colore delle icone
        ),
      ),
      home: MainMenu(),
    );
  }
}
