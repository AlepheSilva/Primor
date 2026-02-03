import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color azulMarinho = const Color(0xFF001F3F);
  final Color douradoPrimor = const Color(0xFFA88E18);

  // Função para deslogar (útil para testes)
  void _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    // Pegamos o UID do usuário atual
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Primor", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: azulMarinho,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          )
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        // Fica "ouvindo" os dados do prestador no Firestore
        stream: FirebaseFirestore.instance.collection('prestadores').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Erro ao carregar perfil."));
          }

          var dados = snapshot.data!.data() as Map<String, dynamic>;
          String nome = dados['nome'] ?? "Prestador";
          String status = dados['status'] ?? "pendente";

          return Column(
            children: [
              // BANNER DE STATUS
              if (status == 'pendente')
                Container(
                  width: double.infinity,
                  color: douradoPrimor.withOpacity(0.9),
                  padding: const EdgeInsets.all(12),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.white),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Seu perfil está em análise manual. Logo você poderá aceitar serviços!",
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Olá, $nome!",
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: azulMarinho),
                    ),
                    const Text("Veja como está o seu dia hoje."),
                    const SizedBox(height: 30),

                    // CARDS DE RESUMO (EXEMPLO)
                    Row(
                      children: [
                        _buildStatCard("Serviços", "0", Icons.work_history),
                        const SizedBox(width: 15),
                        _buildStatCard("Avaliação", "5.0", Icons.star),
                      ],
                    ),
                    
                    const SizedBox(height: 30),
                    const Text(
                      "Últimas Solicitações",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    
                    // ESPAÇO VAZIO (Ainda não há serviços)
                    Center(
                      child: Column(
                        children: [
                          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[300]),
                          const Text("Nenhum serviço disponível no momento.", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String titulo, String valor, IconData icone) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Column(
          children: [
            Icon(icone, color: douradoPrimor),
            const SizedBox(height: 10),
            Text(valor, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(titulo, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}