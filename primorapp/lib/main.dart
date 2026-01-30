import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Importe o pacote aqui
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Primor Prestadores',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D47A1)), // Azul Marinho
        useMaterial3: true,
        // --- A MÁGICA ACONTECE AQUI ---
        // Isso aplica Montserrat em TODOS os textos do app automaticamente
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}