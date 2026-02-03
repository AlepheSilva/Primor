import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'screens/cadastro_passo1.dart'; // Importe sua tela de login/cadastro inicial
import 'screens/home_page.dart';      // Importe sua futura Home (mesmo que seja um rascunho)

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // O 'stream' fica ouvindo o Firebase. Se o usuário logar ou deslogar, ele reage.
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 1. Enquanto o Firebase verifica se há um login salvo
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. Se o usuário estiver logado
        if (snapshot.hasData) {
          return const HomePage(); // Vamos criar um rascunho dela agora
        } 
        
        // 3. Se não houver ninguém logado
        else {
          return const CadastroPasso1();
        }
      },
    );
  }
}