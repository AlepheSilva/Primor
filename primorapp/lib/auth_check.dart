import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 1. Verifique se estes caminhos de arquivos estão corretos na sua pasta 'lib'
import 'screens/login_screen.dart'; 
import 'screens/home_page.dart';
import 'screens/cadastro_passo1.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Verifica se o Firebase está carregando o estado de login
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. CORREÇÃO: Se não houver dados, vai para LoginScreen (nome corrigido)
        if (!snapshot.hasData) {
          return const LoginScreen(); 
        }

        // 3. Se logado, verifica o documento do prestador no Firestore
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('prestadores')
              .doc(snapshot.data!.uid)
              .get(),
          builder: (context, docSnapshot) {
            if (docSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // Se o documento existe, o prestador já terminou o cadastro
            if (docSnapshot.hasData && docSnapshot.data!.exists) {
              return const HomePage();
            } else {
              // Se o usuário existe no Auth mas não no Firestore, volta ao passo 1
              return const CadastroPasso1();
            }
          },
        );
      },
    );
  }
}