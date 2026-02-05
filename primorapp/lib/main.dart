import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Importação das telas e fluxo de autenticação
import 'screens/splash_screen.dart'; // Nova tela inicial

void main() async {
  // Garante que os plugins do Flutter estejam vinculados antes de iniciar o Firebase
  WidgetsFlutterBinding.ensureInitialized(); 
  
  // Inicializa o Firebase com as configurações automáticas
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Definindo as cores oficiais da marca Primor
    const Color azulMarinho = Color(0xFF001F3F);
    const Color douradoPrimor = Color(0xFFA88E18);

    return MaterialApp(
      title: 'Primor',
      debugShowCheckedModeBanner: false,
      
      // Configuração de Idioma (Importante para um app profissional no Brasil)
      // Para usar isso, você pode precisar adicionar 'flutter_localizations' no pubspec
      // locale: const Locale('pt', 'BR'), 

      // Configuração Global de Cores e Estilos (ThemeData)
      theme: ThemeData(
        useMaterial3: true,
        
        // Esquema de cores principal
        colorScheme: ColorScheme.fromSeed(
          seedColor: azulMarinho,
          primary: azulMarinho,
          secondary: douradoPrimor,
          surface: Colors.white,
        ),
        
        // Estilo das AppBars (Menu Superior)
        appBarTheme: const AppBarTheme(
          backgroundColor: azulMarinho,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        // Estilo Global dos Botões (ElevatedButton)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: azulMarinho,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50), // Botões ocupam a largura toda por padrão
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // Estilo de Textos
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: azulMarinho,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(color: azulMarinho),
        ),

        // Estilo dos campos de entrada (InputDecoration)
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: douradoPrimor, width: 2),
          ),
          labelStyle: const TextStyle(color: azulMarinho),
        ),
      ),
      
      // MUDANÇA PRINCIPAL: O app agora "nasce" na Splash Screen
      // Ela exibirá sua logo e slogan por 3 segundos antes de ir ao AuthCheck
      home: const SplashScreen(),
    );
  }
}