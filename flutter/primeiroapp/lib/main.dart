import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: LoginPage()));

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delivery_dining, size: 100, color: Colors.red), // Ícone de Delivery
            SizedBox(height: 20),
            TextField(decoration: InputDecoration(labelText: 'E-mail', border: OutlineInputBorder())),
            SizedBox(height: 10),
            TextField(obscureText: true, decoration: InputDecoration(labelText: 'Senha', border: OutlineInputBorder())),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50), backgroundColor: Colors.red),
              onPressed: () => print("Botão clicado!"),
              child: Text("Entrar", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}