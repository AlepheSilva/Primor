import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importação do Firebase
import 'cadastro_passo1.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // 1. Controladores para capturar o texto digitado
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _passwordVisible = false;
  bool _isLoading = false; // Para mostrar um carregamento no botão

  @override
  void dispose() {
    // Limpar controladores ao fechar a tela para economizar memória
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Função para realizar o Login
  Future<void> _fazerLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Chamada oficial ao Firebase
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Se o login for bem-sucedido:
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Bem-vindo ao Primor!"),
              backgroundColor: Colors.green,
            ),
          );
          // TODO: Navegar para a tela Home aqui
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
      } on FirebaseAuthException catch (e) {
        String mensagem = "Erro ao entrar";
        
        if (e.code == 'user-not-found') {
          mensagem = "E-mail não encontrado.";
        } else if (e.code == 'wrong-password') {
          mensagem = "Senha incorreta.";
        } else if (e.code == 'invalid-email') {
          mensagem = "Formato de e-mail inválido.";
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(mensagem), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

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
              const Icon(
                Icons.verified_user_rounded,
                size: 90,
                color: Color(0xFF001F3F),
              ),
              const SizedBox(height: 10),
              
              // Nome do App: Primor (Dourado)
              const Text(
                "PRIMOR",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFA88E18),
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
                controller: _emailController, // Vínculo com controlador
                keyboardType: TextInputType.emailAddress,
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
                controller: _passwordController, // Vínculo com controlador
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  labelText: "Senha",
                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF001F3F)),
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
                    ? "Senha muito curta (mínimo 6 caracteres)"
                    : null,
              ),
              const SizedBox(height: 30),

              // Botão Entrar
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: const Color(0xFF001F3F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _isLoading ? null : _fazerLogin,
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
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
                  style: TextStyle(color: Color(0xFFA88E18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}