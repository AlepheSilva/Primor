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

  // Cores da Identidade Primor
  final Color azulMarinho = const Color(0xFF001F3F);
  final Color douradoPrimor = const Color(0xFFA88E18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Passo 1 de 3"),
        backgroundColor: azulMarinho,
        foregroundColor: Colors.white,
        centerTitle: true, // Garante o título centralizado na AppBar
        elevation: 0,
      ),
      body: Center( // Centraliza o conteúdo verticalmente na tela
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centraliza os filhos na Column
              crossAxisAlignment: CrossAxisAlignment.stretch, // Estica os campos horizontalmente
              children: [
                Text(
                  "Dados de Acesso",
                  textAlign: TextAlign.center, // Centraliza o texto do título
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold, 
                    color: azulMarinho
                  ),
                ),
                const SizedBox(height: 30),

                // 1. NOME COMPLETO
                _buildField(
                  label: "Nome Completo", 
                  icon: Icons.person_outline,
                  validator: (value) => (value == null || value.isEmpty) ? "Campo obrigatório" : null,
                ),
                const SizedBox(height: 15),

                // 2. CPF
                _buildField(
                  label: "CPF", 
                  icon: Icons.badge_outlined,
                  keyboard: TextInputType.number,
                  validator: (value) => (value == null || value.length < 11) ? "CPF inválido" : null,
                ),
                const SizedBox(height: 15),

                // 3. TELEFONE
                _buildField(
                  label: "Telefone / WhatsApp", 
                  icon: Icons.phone_android_outlined,
                  keyboard: TextInputType.phone,
                  validator: (value) => (value == null || value.isEmpty) ? "Campo obrigatório" : null,
                ),
                const SizedBox(height: 15),

                // 4. E-MAIL
                _buildField(
                  label: "E-mail", 
                  icon: Icons.email_outlined,
                  keyboard: TextInputType.emailAddress,
                  validator: (value) => (value == null || !value.contains("@")) ? "E-mail inválido" : null,
                ),
                const SizedBox(height: 15),

                // 5. SENHA
                TextFormField(
                  obscureText: !_mostrarSenha,
                  decoration: InputDecoration(
                    labelText: "Crie uma Senha",
                    prefixIcon: Icon(Icons.lock_outline, color: azulMarinho),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _mostrarSenha ? Icons.visibility : Icons.visibility_off,
                        color: azulMarinho,
                      ),
                      onPressed: () => setState(() => _mostrarSenha = !_mostrarSenha),
                    ),
                  ),
                  validator: (value) => (value == null || value.length < 6) ? "Mínimo 6 caracteres" : null,
                ),
                const SizedBox(height: 40),

                // BOTÃO PRÓXIMO
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: azulMarinho,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CadastroPasso2()),
                      );
                    }
                  },
                  child: const Text(
                    "PRÓXIMO PASSO",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Função para criar os campos repetitivos de forma limpa
  Widget _buildField({
    required String label, 
    required IconData icon, 
    TextInputType? keyboard,
    String? Function(String?)? validator
  }) {
    return TextFormField(
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: azulMarinho),
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }
}