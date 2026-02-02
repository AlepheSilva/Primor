import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart'; // [1] Nova Importação
import 'firebase_options.dart'; // [2] Será gerado automaticamente
import 'screens/login_screen.dart';

// [3] O main agora precisa ser 'async' (assíncrono)
void main() async {
  // [4] Garante que os componentes do Flutter estejam prontos
  WidgetsFlutterBinding.ensureInitialized();

  // [5] Inicializa o Firebase antes do App rodar
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        // Mantendo sua configuração de fonte Montserrat
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}