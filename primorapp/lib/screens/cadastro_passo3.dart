import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroPasso3 extends StatefulWidget {
  const CadastroPasso3({super.key});

  @override
  State<CadastroPasso3> createState() => _CadastroPasso3State();
}

class _CadastroPasso3State extends State<CadastroPasso3> {
  final Color azulMarinho = const Color(0xFF001F3F);
  final Color douradoPrimor = const Color(0xFFA88E18);

  File? fotoPerfil;
  File? documentoFrente;
  File? documentoVerso;
  bool _carregando = false;

  Future<void> _pegarImagem(String tipo) async {
    final ImagePicker picker = ImagePicker();
    
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Tirar Foto"),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text("Escolher da Galeria"),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    );

    if (source != null) {
      final XFile? pickedFile = await picker.pickImage(source: source, imageQuality: 50);
      if (pickedFile != null) {
        setState(() {
          if (tipo == 'perfil') fotoPerfil = File(pickedFile.path);
          if (tipo == 'frente') documentoFrente = File(pickedFile.path);
          if (tipo == 'verso') documentoVerso = File(pickedFile.path);
        });
      }
    }
  }

  Future<void> _finalizarCadastro() async {
    setState(() => _carregando = true);
    
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // SIMULAÇÃO DE UPLOAD (Aguardamos 2 segundos para dar realismo)
      await Future.delayed(const Duration(seconds: 2));

      // ATUALIZAÇÃO DO FIRESTORE
      // Definimos cadastroCompleto como TRUE para o AuthCheck liberar a Home
      await FirebaseFirestore.instance.collection('prestadores').doc(uid).update({
        'urlFotoPerfil': 'simulada_pendente',
        'urlDocFrente': 'simulada_pendente',
        'urlDocVerso': 'simulada_pendente',
        'status': 'verificacao_manual', 
        'cadastroCompleto': true, // PONTO CHAVE: Agora o AuthCheck verá isso
        'dataFinalizacao': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      _showSucessoDialog();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao salvar cadastro: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  void _showSucessoDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Sucesso!", style: TextStyle(color: azulMarinho, fontWeight: FontWeight.bold)),
        content: const Text("Seu perfil foi enviado para análise! Agora você já pode acessar o painel do Primor."),
        actions: [
          TextButton(
            onPressed: () {
              // Primeiro fechamos o Alerta
              Navigator.of(context).pop();
              // Depois limpamos a pilha de navegação para o AuthCheck assumir o controle
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text("ENTRAR NO APP", style: TextStyle(color: douradoPrimor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Passo 3 de 3"),
        backgroundColor: azulMarinho,
        foregroundColor: Colors.white,
      ),
      body: _carregando 
        ? Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: azulMarinho),
              const SizedBox(height: 20),
              const Text("Enviando para análise...", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Verificação de Segurança",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: azulMarinho),
                ),
                const SizedBox(height: 30),

                _buildUploadCard(
                  titulo: "Sua Foto de Perfil",
                  subtitulo: "Tire uma selfie nítida",
                  icone: Icons.face_retouching_natural,
                  concluido: fotoPerfil != null,
                  onTap: () => _pegarImagem('perfil'),
                ),
                const SizedBox(height: 15),

                _buildUploadCard(
                  titulo: "Documento (Frente)",
                  subtitulo: "RG ou CNH aberta",
                  icone: Icons.credit_card,
                  concluido: documentoFrente != null,
                  onTap: () => _pegarImagem('frente'),
                ),
                const SizedBox(height: 15),

                _buildUploadCard(
                  titulo: "Documento (Verso)",
                  subtitulo: "Parte de trás",
                  icone: Icons.style_outlined,
                  concluido: documentoVerso != null,
                  onTap: () => _pegarImagem('verso'),
                ),

                const SizedBox(height: 40),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: azulMarinho,
                  ),
                  onPressed: (fotoPerfil != null && documentoFrente != null && documentoVerso != null)
                      ? _finalizarCadastro
                      : null,
                  child: const Text(
                    "FINALIZAR CADASTRO",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildUploadCard({
    required String titulo,
    required String subtitulo,
    required IconData icone,
    required bool concluido,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: concluido ? Colors.green : azulMarinho.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
          color: concluido ? Colors.green.withOpacity(0.05) : Colors.grey[50],
        ),
        child: Row(
          children: [
            Icon(concluido ? Icons.check_circle : icone, size: 40, color: concluido ? Colors.green : azulMarinho),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(subtitulo, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                ],
              ),
            ),
            Icon(Icons.camera_alt_outlined, color: douradoPrimor),
          ],
        ),
      ),
    );
  }
}