import 'package:flutter/material.dart';
import 'cadastro_passo1.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key}); // Adicione esta linha!

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 80),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Ícone de Escudo
              Icon(
                Icons.verified_user_rounded,
                size: 90,
                color: Colors.blue[900],
              ),
              SizedBox(height: 10),
              // Nome do App: Primor
              Text(
                "PRIMOR",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold, // Montserrat Bold fica linda!
                  color: const Color.fromARGB(255, 168, 142, 24),
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
                  // Não precisa mais declarar a fontFamily, ela já é Montserrat!
                ),
              ),
              SizedBox(height: 40),
              // Campo E-mail
              TextFormField(
                decoration: InputDecoration(
                  labelText: "E-mail",
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? "Campo obrigatório"
                    : null,
              ),
              SizedBox(height: 20),
              // Campo Senha
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Senha",
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) => (value == null || value.length < 6)
                    ? "Senha muito curta"
                    : null,
              ),
              SizedBox(height: 30),
              // Botão Entrar
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.blue[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print("Logando...");
                  }
                },
                child: Text("ENTRAR", style: TextStyle(color: Colors.white)),
              ),
              // Ir para Cadastro
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CadastroPasso1()),
                  );
                },
                child: Text("Quero me tornar um prestador Primor"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
