import 'package:flutter/material.dart';

class CadastroPasso3 extends StatefulWidget {
  const CadastroPasso3({super.key});

  @override
  State<CadastroPasso3> createState() => _CadastroPasso3State();
}

class _CadastroPasso3State extends State<CadastroPasso3> {
  final Color azulMarinho = const Color(0xFF001F3F);
  final Color douradoPrimor = const Color(0xFFA88E18);

  // Estados para simular que a foto foi tirada
  bool fotoPerfilOk = false;
  bool documentoFrenteOk = false;
  bool documentoVersoOk = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Passo 3 de 3"),
        backgroundColor: azulMarinho,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Verificação de Segurança",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: azulMarinho),
            ),
            const SizedBox(height: 10),
            const Text(
              "Para sua segurança e dos nossos clientes, precisamos confirmar sua identidade.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // 1. UPLOAD DA SELFIE
            _buildUploadCard(
              titulo: "Sua Foto de Perfil",
              subtitulo: "Tire uma selfie nítida de frente",
              icone: Icons.face_retouching_natural,
              concluido: fotoPerfilOk,
              onTap: () => setState(() => fotoPerfilOk = !fotoPerfilOk), // Simulação
            ),
            
            const SizedBox(height: 15),

            // 2. UPLOAD RG/CNH FRENTE
            _buildUploadCard(
              titulo: "Documento (Frente)",
              subtitulo: "RG ou CNH aberta e legível",
              icone: Icons.credit_card,
              concluido: documentoFrenteOk,
              onTap: () => setState(() => documentoFrenteOk = !documentoFrenteOk),
            ),

            const SizedBox(height: 15),

            // 3. UPLOAD RG/CNH VERSO
            _buildUploadCard(
              titulo: "Documento (Verso)",
              subtitulo: "Parte de trás do documento",
              icone: Icons.style_outlined,
              concluido: documentoVersoOk,
              onTap: () => setState(() => documentoVersoOk = !documentoVersoOk),
            ),

            const SizedBox(height: 40),

            // BOTÃO FINALIZAR
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                backgroundColor: azulMarinho,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: (fotoPerfilOk && documentoFrenteOk && documentoVersoOk)
                  ? () {
                      _showSucessoDialog();
                    }
                  : null, // Desabilitado até que todas as fotos sejam enviadas
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

  // Widget personalizado para os botões de upload
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

  void _showSucessoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Sucesso!", style: TextStyle(color: azulMarinho)),
        content: const Text("Seu perfil foi enviado para análise. Em breve você poderá começar a trabalhar!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: Text("OK", style: TextStyle(color: douradoPrimor)),
          ),
        ],
      ),
    );
  }
}