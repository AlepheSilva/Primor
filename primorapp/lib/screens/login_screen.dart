import 'package:flutter/material.dart';
import 'cadastro_passo1.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // 1. Variável para controlar a visibilidade da senha
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Ícone de Escudo (Azul Marinho)
              Icon(
                Icons.verified_user_rounded,
                size: 90,
                color: const Color(0xFF001F3F), // Azul Marinho
              ),
              const SizedBox(height: 10),
              
              // Nome do App: Primor (Dourado)
              const Text(
                "PRIMOR",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFA88E18), // Dourado Primor
                  letterSpacing: 1.2,
                ),
              ),

              // Slogan
              Text(
                "Serviços Residenciais",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),

              // Campo E-mail
              TextFormField(
                decoration: InputDecoration(
                  labelText: "E-mail",
                  prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF001F3F)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? "Campo obrigatório"
                    : null,
              ),
              const SizedBox(height: 20),

              // Campo Senha com o "Olhinho"
              TextFormField(
                obscureText: !_passwordVisible, // Inverte para esconder/mostrar
                decoration: InputDecoration(
                  labelText: "Senha",
                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF001F3F)),
                  // Botão do Olhinho
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: const Color(0xFF001F3F),
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) => (value == null || value.length < 6)
                    ? "Senha muito curta"
                    : null,
              ),
              const SizedBox(height: 30),

              // Botão Entrar
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: const Color(0xFF001F3F), // Azul Marinho
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print("Logando...");
                  }
                },
                child: const Text(
                  "ENTRAR", 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                ),
              ),

              // Ir para Cadastro
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CadastroPasso1()),
                  );
                },
                child: const Text(
                  "Quero me tornar um prestador Primor",
                  style: TextStyle(color: Color(0xFFA88E18)), // Dourado
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}