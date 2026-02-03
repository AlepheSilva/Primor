import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // NOVO: Importação do Firebase
import 'cadastro_passo2.dart';

class CadastroPasso1 extends StatefulWidget {
  const CadastroPasso1({super.key});

  @override
  State<CadastroPasso1> createState() => _CadastroPasso1State();
}

class _CadastroPasso1State extends State<CadastroPasso1> {
  final _formKey = GlobalKey<FormState>();
  
  // NOVO: Controladores agora ficam aqui dentro para melhor organização
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

  bool _mostrarSenha = false;
  bool _carregando = false; // NOVO: Para mostrar um feedback de carregamento

  // Cores da Identidade Primor
  final Color azulMarinho = const Color(0xFF001F3F);
  final Color douradoPrimor = const Color(0xFFA88E18);

  // NOVO: Função que cria a conta no Firebase
  Future<void> _proximoPasso() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _carregando = true);
      
      try {
        // Criando o usuário no Firebase Auth
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _senhaController.text.trim(),
        );

        // Se deu certo, navegamos para o Passo 2
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CadastroPasso2()),
        );
      } on FirebaseAuthException catch (e) {
        String mensagem = "Ocorreu um erro ao cadastrar.";
        if (e.code == 'email-already-in-use') {
          mensagem = "Este e-mail já está em uso.";
        } else if (e.code == 'weak-password') {
          mensagem = "A senha é muito fraca.";
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mensagem), backgroundColor: Colors.red),
        );
      } finally {
        setState(() => _carregando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Passo 1 de 3"),
        backgroundColor: azulMarinho,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Dados de Acesso",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold, 
                    color: azulMarinho
                  ),
                ),
                const SizedBox(height: 30),

                _buildField(
                  label: "Nome Completo", 
                  icon: Icons.person_outline,
                  controller: _nomeController,
                  validator: (value) => (value == null || value.isEmpty) ? "Campo obrigatório" : null,
                ),
                const SizedBox(height: 15),

                _buildField(
                  label: "CPF", 
                  icon: Icons.badge_outlined,
                  controller: _cpfController,
                  keyboard: TextInputType.number,
                  validator: (value) => (value == null || value.length < 11) ? "CPF inválido" : null,
                ),
                const SizedBox(height: 15),

                _buildField(
                  label: "Telefone / WhatsApp", 
                  icon: Icons.phone_android_outlined,
                  controller: _telefoneController,
                  keyboard: TextInputType.phone,
                  validator: (value) => (value == null || value.isEmpty) ? "Campo obrigatório" : null,
                ),
                const SizedBox(height: 15),

                _buildField(
                  label: "E-mail", 
                  icon: Icons.email_outlined,
                  controller: _emailController,
                  keyboard: TextInputType.emailAddress,
                  validator: (value) => (value == null || !value.contains("@")) ? "E-mail inválido" : null,
                ),
                const SizedBox(height: 15),

                TextFormField(
                  controller: _senhaController,
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

                // BOTÃO PRÓXIMO COM FEEDBACK DE CARREGAMENTO
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: azulMarinho,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _carregando ? null : _proximoPasso,
                  child: _carregando 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
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

  // Função atualizada para aceitar o controller
  Widget _buildField({
    required String label, 
    required IconData icon, 
    required TextEditingController controller,
    TextInputType? keyboard,
    String? Function(String?)? validator
  }) {
    return TextFormField(
      controller: controller,
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