import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Adicionado para autenticação
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'screens/cadastro_passo1.dart'; // Import para o botão de cadastro
// import 'screens/home_page.dart'; // Descomente quando criar a tela home

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color azulMarinho = Color(0xFF001F3F);
    const Color douradoPrimor = Color(0xFFA88E18);

    return MaterialApp(
      title: 'Primor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: azulMarinho,
          primary: azulMarinho,
          secondary: douradoPrimor,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: azulMarinho,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: azulMarinho,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      // O app inicia na Splash que decide se vai para Login ou Home
      home: const SplashScreen(),
    );
  }
}

// --- CLASSE DA TELA DE LOGIN ---
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _carregando = false;

  Future<void> _fazerLogin() async {
    setState(() => _carregando = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text.trim(),
      );

      // SUCESSO: Navegar para a Home
      if (!mounted) return;
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
      print("Login realizado com sucesso! Redirecionando...");

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: ${e.message}"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("PRIMOR", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF001F3F))),
            const SizedBox(height: 30),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "E-mail")),
            const SizedBox(height: 15),
            TextField(controller: _senhaController, obscureText: true, decoration: const InputDecoration(labelText: "Senha")),
            const SizedBox(height: 30),
            
            ElevatedButton(
              onPressed: _carregando ? null : _fazerLogin,
              child: _carregando ? const CircularProgressIndicator(color: Colors.white) : const Text("ENTRAR"),
            ),
            
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CadastroPasso1()));
              },
              child: const Text("Não tem conta? Cadastre-se aqui"),
            ),
          ],
        ),
      ),
    );
  }
}