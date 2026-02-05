import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Imports das suas telas
import 'screens/login_screen.dart'; 
import 'screens/home_page.dart';
import 'screens/cadastro_passo1.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    // Primeiro Stream: Ouve se o usuário está logado ou não
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 1. Se não houver usuário logado, vai para o Login
        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        // 2. Se estiver logado, usamos um segundo Stream para vigiar o documento no Firestore
        // Isso garante que o app mude de tela SOZINHO assim que o Passo 3 terminar
        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('prestadores')
              .doc(snapshot.data!.uid)
              .snapshots(), // .snapshots() em vez de .get() para ser em tempo real
          builder: (context, docSnapshot) {
            if (docSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // Lógica de Direcionamento
            if (docSnapshot.hasData && docSnapshot.data!.exists) {
              final dados = docSnapshot.data!.data() as Map<String, dynamic>;
              
              // Se o cadastro estiver marcado como completo, libera a Home
              if (dados['cadastroCompleto'] == true) {
                return const HomePage();
              }
            }

            // Se o documento não existir ou o cadastro ainda estiver incompleto,
            // mantém o usuário nas telas de cadastro
            return const CadastroPasso1();
          },
        );
      },
    );
  }
}