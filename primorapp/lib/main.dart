import 'package:flutter/material.dart';

void main() {
  runApp(const PrimorApp());
}

class PrimorApp extends StatelessWidget {
  const PrimorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Primor: Serviços Residenciais',
      debugShowCheckedModeBanner: false,
      // Configuração do Tema "Tradicional e Sério"
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B264F),
          primary: const Color(0xFF1B264F), // Azul Profundo
          secondary: const Color(0xFFC5A059), // Dourado
          surface: const Color(0xFFFAFAFA), // Fundo Gelo
        ),
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1B264F),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1B264F),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Temporário (Texto)
                const Icon(Icons.shield_outlined, size: 80, color: Color(0xFFC5A059)),
                const SizedBox(height: 10),
                const Text(
                  'PRIMOR',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                    color: Color(0xFF1B264F),
                  ),
                ),
                const Text(
                  'SERVIÇOS RESIDENCIAIS',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFC5A059),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 60),
                
                // Campo de E-mail
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Campo de Senha
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Esqueceu a senha?'),
                  ),
                ),
                const SizedBox(height: 30),
                
                // Botão de Entrar
                ElevatedButton(
                  onPressed: () {
                    // Lógica de login entrará aqui
                  },
                  child: const Text('ENTRAR', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Ainda não tem conta?'),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Cadastre-se', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}