import 'package:flutter/material.dart';
import 'cadastro_passo2.dart';

class CadastroPasso1 extends StatefulWidget {
  const CadastroPasso1({super.key});

  @override
  State<CadastroPasso1> createState() => _CadastroPasso1State();
}

class _CadastroPasso1State extends State<CadastroPasso1> {
  final _formKey = GlobalKey<FormState>();

  bool _mostrarSenha = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crie sua Conta"),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Dados de Acesso",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // 1. NOME COMPLETO
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Nome Completo",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? "Campo obrigatório"
                    : null,
              ),
              const SizedBox(height: 15),

              // 2. CPF
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "CPF",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (value) => (value == null || value.length < 11)
                    ? "CPF inválido"
                    : null,
              ),
              const SizedBox(height: 15),

              // 3. TELEFONE
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Telefone / WhatsApp",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? "Campo obrigatório"
                    : null,
              ),
              const SizedBox(height: 15),

              // 4. E-MAIL
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "E-mail",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) => (value == null || !value.contains("@"))
                    ? "E-mail inválido"
                    : null,
              ),
              const SizedBox(height: 15),

              // 5. SENHA COM BOTÃO DE MOSTRAR/ESCONDER
              TextFormField(
                obscureText:
                    !_mostrarSenha, // Se _mostrarSenha for falso, ele esconde (usa a exclamação para inverter)
                decoration: InputDecoration(
                  labelText: "Crie uma Senha",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  // Aqui adicionamos o ícone no final do campo
                  suffixIcon: IconButton(
                    icon: Icon(
                      _mostrarSenha ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      // O setState avisa o Flutter para redesenhar a tela com a mudança
                      setState(() {
                        _mostrarSenha = !_mostrarSenha;
                      });
                    },
                  ),
                ),
                validator: (value) => (value == null || value.length < 6)
                    ? "Mínimo 6 caracteres"
                    : null,
              ),
              const SizedBox(height: 30),

              // BOTÃO PRÓXIMO
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: Colors.blue[900],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CadastroPasso2(),
                      ),
                    );
                  }
                },
                child: const Text(
                  "PRÓXIMO PASSO",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
