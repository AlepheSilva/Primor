import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Substitua pelos nomes reais dos seus arquivos
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
        // 1. Se o Firebase ainda estiver carregando a resposta
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. Se o usuário NÃO está logado, vai para o Login
        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        // 3. Se o usuário ESTÁ logado, precisamos checar se ele terminou o cadastro no Firestore
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('prestadores')
              .doc(snapshot.data!.uid)
              .get(),
          builder: (context, docSnapshot) {
            if (docSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            // Se o documento existe e o cadastro está completo, vai para a Home
            if (docSnapshot.hasData && docSnapshot.data!.exists) {
              // Aqui você pode verificar um campo específico, ex: 'cadastroCompleto'
              return const HomePage();
            } else {
              // Se logou mas não tem documento no Firestore, manda terminar o cadastro
              return const CadastroPasso1();
            }
          },
        );
      },
    );
  }
}