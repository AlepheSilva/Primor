import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart'; // Certifique-se de que o caminho está correto

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Identidade Visual Primor
  final Color azulMarinho = const Color(0xFF001F3F);
  final Color douradoPrimor = const Color(0xFFA88E18);

  bool _isOnline = false;
  bool _isDarkMode = false;

  // Função de Logout com redirecionamento para evitar tela preta
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Verificação de segurança para o usuário atual
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return const LoginScreen();

    final String uid = user.uid;
    
    // Definição das cores baseada no Modo Escuro
    final backgroundColor = _isDarkMode ? const Color(0xFF121212) : Colors.grey[50];
    final cardColor = _isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = _isDarkMode ? Colors.white : const Color(0xFF001F3F);

    return Scaffold(
      backgroundColor: backgroundColor,
      // endDrawer coloca o menu sanduíche na direita
      endDrawer: _buildDrawer(user.email ?? ""), 
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _isDarkMode ? Colors.black : azulMarinho,
        centerTitle: true,
        title: const Text(
          "PRIMOR",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        // Lado Esquerdo: Switch de Status Online
        leadingWidth: 80,
        leading: Center(
          child: Switch(
            value: _isOnline,
            activeColor: Colors.greenAccent,
            onChanged: (value) {
              setState(() => _isOnline = value);
              // Opcional: Atualizar status no Firestore aqui
            },
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('prestadores').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var dados = snapshot.data?.data() as Map<String, dynamic>? ?? {};
          String nome = dados['nome'] ?? "Prestador";

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(nome, textColor),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatusCard(cardColor, textColor),
                      const SizedBox(height: 25),
                      Text(
                        "Resumo de hoje",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          _buildStatCard("Ganhos", "R\$ 0,00", Icons.account_balance_wallet, cardColor, textColor),
                          const SizedBox(width: 15),
                          _buildStatCard("Serviços", "0", Icons.handyman, cardColor, textColor),
                        ],
                      ),
                      const SizedBox(height: 30),
                      _buildEmptyState(textColor),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(String nome, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bem-vindo, $nome",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor),
          ),
          Text(
            _isOnline ? "Você está online e visível" : "Você está em pausa",
            style: TextStyle(
              color: _isOnline ? Colors.green : Colors.grey[600], 
              fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(Color cardColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: _isOnline ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _isOnline ? Colors.green : Colors.orange),
      ),
      child: Row(
        children: [
          Icon(
            _isOnline ? Icons.check_circle : Icons.pause_circle_filled,
            color: _isOnline ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 12),
          Text(
            _isOnline ? "Aguardando novos serviços..." : "Modo Offline",
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(String email) {
    return Drawer(
      backgroundColor: _isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: azulMarinho),
            accountName: const Text("Menu Primor", style: TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text(email),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Color(0xFF001F3F)),
            ),
          ),
          _drawerItem(Icons.person_outline, "Meu Perfil"),
          _drawerItem(Icons.account_balance_wallet_outlined, "Minha Carteira"),
          ListTile(
            leading: Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode, color: douradoPrimor),
            title: Text("Modo Escuro", style: TextStyle(color: _isDarkMode ? Colors.white : azulMarinho)),
            trailing: Switch(
              value: _isDarkMode,
              onChanged: (value) => setState(() => _isDarkMode = value),
            ),
          ),
          const Spacer(), // Empurra o que vem abaixo para o final
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text("Sair da Conta", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            onTap: _logout,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: douradoPrimor),
      title: Text(title, style: TextStyle(color: _isDarkMode ? Colors.white : azulMarinho)),
      onTap: () {},
    );
  }

  Widget _buildStatCard(String titulo, String valor, IconData icone, Color cardColor, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4)
            )
          ],
        ),
        child: Column(
          children: [
            Icon(icone, color: douradoPrimor, size: 28),
            const SizedBox(height: 10),
            Text(valor, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            Text(titulo, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color textColor) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 50),
          Icon(Icons.search, size: 70, color: douradoPrimor.withOpacity(0.2)),
          const SizedBox(height: 10),
          Text(
            "Nenhum serviço disponível no momento",
            style: TextStyle(color: textColor.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }
}