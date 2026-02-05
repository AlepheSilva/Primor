import 'dart:async';
import 'package:flutter/material.dart';
import '../auth_check.dart'; // Verifique se o caminho está correto para sua pasta

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Aguarda 3 segundos e navega para o fluxo de autenticação
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthCheck()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Cores oficiais do Primor
    const Color azulMarinho = Color(0xFF001F3F);
    const Color douradoPrimor = Color(0xFFA88E18);

    return Scaffold(
      backgroundColor: azulMarinho,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Nome do App com destaque
                const Text(
                  "PRIMOR",
                  style: TextStyle(
                    fontSize: 48, // Tamanho maior já que não tem logo
                    fontWeight: FontWeight.bold,
                    color: douradoPrimor,
                    letterSpacing: 8, // Espaçamento elegante entre letras
                  ),
                ),
                const SizedBox(height: 10),
                // Novo Slogan
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "Conectando você aos melhores especialistas",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Indicador de carregamento sutil na parte inferior
          const Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(
                color: douradoPrimor,
                strokeWidth: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}