import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cadastro_passo1.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _passwordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _fazerLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Bem-vindo ao Primor!"),
              backgroundColor: Colors.green,
            ),
          );

          // REDIRECIONAMENTO MANUAL
          // Como você disse que ele não estava mudando de tela, 
          // vamos forçar a navegação para a sua Home/Dashboard aqui.
          // Se sua tela inicial se chamar HomePage, use o código abaixo:
          /*
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
          */
        }
      } on FirebaseAuthException catch (e) {
        String mensagem = "Erro ao entrar";
        
        if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
          mensagem = "E-mail ou senha incorretos.";
        } else if (e.code == 'invalid-email') {
          mensagem = "O formato do e-mail é inválido.";
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
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.verified_user_rounded, size: 90, color: primaryColor),
                const SizedBox(height: 10),
                Text(
                  "PRIMOR",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  "Conectando você aos melhores especialistas.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 40),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "E-mail",
                    prefixIcon: Icon(Icons.email_outlined, color: primaryColor),
                  ),
                  validator: (value) => (value == null || !value.contains('@')) ? "E-mail inválido" : null,
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: "Senha",
                    prefixIcon: Icon(Icons.lock_outline, color: primaryColor),
                    suffixIcon: IconButton(
                      icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off, color: primaryColor),
                      onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                    ),
                  ),
                  validator: (value) => (value == null || value.length < 6) ? "Mínimo 6 caracteres" : null,
                ),
                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: _isLoading ? null : _fazerLogin,
                  child: _isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("ENTRAR"),
                ),

                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CadastroPasso1()),
                    );
                  },
                  child: Text(
                    "Quero me tornar um prestador Primor",
                    style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}