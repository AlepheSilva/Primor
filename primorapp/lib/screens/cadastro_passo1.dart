import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:primorapp/screens/login_screen.dart'; 
import 'cadastro_passo2.dart';

class CadastroPasso1 extends StatefulWidget {
  const CadastroPasso1({super.key});

  @override
  State<CadastroPasso1> createState() => _CadastroPasso1State();
}

class _CadastroPasso1State extends State<CadastroPasso1> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

  final maskCPF = MaskTextInputFormatter(
    mask: '###.###.###-##', 
    filter: {"#": RegExp(r'[0-9]')}
  );

  final maskTelefone = MaskTextInputFormatter(
    mask: '(##)#####-####', 
    filter: {"#": RegExp(r'[0-9]')}
  );

  bool _mostrarSenha = false;
  bool _carregando = false;

  final Color azulMarinho = const Color(0xFF001F3F);
  final Color douradoPrimor = const Color(0xFFA88E18);

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _nomeController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  Future<void> _proximoPasso() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _carregando = true);
      
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _senhaController.text.trim(),
        );

        String uid = userCredential.user!.uid;
        await FirebaseFirestore.instance.collection('prestadores').doc(uid).set({
          'nome': _nomeController.text.trim(),
          'cpf': _cpfController.text.trim(),
          'telefone': _telefoneController.text.trim(),
          'email': _emailController.text.trim(),
          'cadastroCompleto': false,
          'status': 'em_cadastro',
          'dataCriacao': FieldValue.serverTimestamp(),
        });

        if (!mounted) return;
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CadastroPasso2()));

      } on FirebaseAuthException catch (e) {
        String mensagem = "Ocorreu um erro ao cadastrar.";
        if (e.code == 'email-already-in-use') mensagem = "Este e-mail já está em uso.";
        else if (e.code == 'weak-password') mensagem = "Senha muito fraca.";
        
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem), backgroundColor: Colors.red));
      } finally {
        if (mounted) setState(() => _carregando = false);
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
        automaticallyImplyLeading: false, 
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Dados de Acesso", textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: azulMarinho)),
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
                  inputFormatters: [maskCPF],
                  validator: (value) => (value == null || value.length < 14) ? "CPF incompleto" : null,
                ),
                const SizedBox(height: 15),

                _buildField(
                  label: "Telefone / WhatsApp", 
                  icon: Icons.phone_android_outlined,
                  controller: _telefoneController,
                  keyboard: TextInputType.phone,
                  inputFormatters: [maskTelefone],
                  validator: (value) => (value == null || value.length < 13) ? "Telefone incompleto" : null,
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
                      icon: Icon(_mostrarSenha ? Icons.visibility : Icons.visibility_off, color: azulMarinho),
                      onPressed: () => setState(() => _mostrarSenha = !_mostrarSenha),
                    ),
                  ),
                  validator: (value) => (value == null || value.length < 6) ? "Mínimo 6 caracteres" : null,
                ),
                const SizedBox(height: 30),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18), 
                    backgroundColor: azulMarinho,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _carregando ? null : _proximoPasso,
                  child: _carregando 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("PRÓXIMO PASSO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                ),

                const SizedBox(height: 15),

                // BOTÃO DE VOLTAR REFORMULADO PARA EVITAR TELA PRETA
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context, 
                      MaterialPageRoute(builder: (context) => const LoginScreen()), // Redireciona para o Login no main.dart
                      (route) => false, // Remove todas as outras telas da memória
                    );
                  },
                  child: Text(
                    "Já tem uma conta? Voltar para o Login",
                    style: TextStyle(
                      color: azulMarinho.withOpacity(0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label, 
    required IconData icon, 
    required TextEditingController controller,
    TextInputType? keyboard,
    List<MaskTextInputFormatter>? inputFormatters,
    String? Function(String?)? validator
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: azulMarinho),
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }
}