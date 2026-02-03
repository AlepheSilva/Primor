import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // NOVO
import 'package:firebase_auth/firebase_auth.dart'; // NOVO
import 'cadastro_passo3.dart';

class CadastroPasso2 extends StatefulWidget {
  const CadastroPasso2({super.key});

  @override
  State<CadastroPasso2> createState() => _CadastroPasso2State();
}

class _CadastroPasso2State extends State<CadastroPasso2> {
  // Cores da Identidade Primor
  final Color azulMarinho = const Color(0xFF001F3F);
  final Color douradoPrimor = const Color(0xFFA88E18);

  bool _carregando = false; // NOVO: Feedback visual

  // Lista de especialidades selecionadas
  final List<String> _especialidadesSelecionadas = [];

  // Mapa de Categorias e Serviços
  final Map<String, List<String>> _categorias = {
    "Elétrica e Climatização": ["Eletricista", "Ar-condicionado", "Antenas/Interfones"],
    "Hidráulica e Gás": ["Encanador", "Desentupidor", "Aquecedores a Gás"],
    "Reformas e Acabamentos": ["Pintor", "Pedreiro", "Gesseiro", "Marceneiro"],
    "Serviços Gerais e Lar": ["Marido de Aluguel", "Montador de Móveis", "Jardineiro", "Limpeza"],
  };

  // NOVO: Função para salvar as especialidades no Firestore
  Future<void> _salvarEspecialidades() async {
    setState(() => _carregando = true);
    
    try {
      // Pega o ID do prestador logado
      String? uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid != null) {
        // Salva/Atualiza no Firestore na coleção 'prestadores'
        await FirebaseFirestore.instance.collection('prestadores').doc(uid).set({
          'especialidades': _especialidadesSelecionadas,
          'passoCadastro': 2,
          'atualizadoEm': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true)); // Merge para não apagar dados do Passo 1

        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CadastroPasso3()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao salvar: $e"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Passo 2 de 3"),
        backgroundColor: azulMarinho,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "O que você faz de melhor?",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: azulMarinho),
                  ),
                  const SizedBox(height: 8),
                  const Text("Selecione suas especialidades (você pode escolher várias).",
                      style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 24),

                  ..._categorias.entries.map((categoria) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            categoria.key,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: douradoPrimor),
                          ),
                        ),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: categoria.value.map((servico) {
                            final bool selecionado = _especialidadesSelecionadas.contains(servico);
                            return FilterChip(
                              label: Text(servico),
                              labelStyle: TextStyle(
                                color: selecionado ? douradoPrimor : azulMarinho,
                                fontWeight: selecionado ? FontWeight.bold : FontWeight.normal,
                              ),
                              selected: selecionado,
                              onSelected: (bool value) {
                                setState(() {
                                  if (value) {
                                    _especialidadesSelecionadas.add(servico);
                                  } else {
                                    _especialidadesSelecionadas.remove(servico);
                                  }
                                });
                              },
                              backgroundColor: Colors.white,
                              selectedColor: azulMarinho,
                              checkmarkColor: douradoPrimor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: azulMarinho),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),

          // Rodapé com o botão
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                backgroundColor: azulMarinho,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: (_especialidadesSelecionadas.isEmpty || _carregando)
                  ? null 
                  : _salvarEspecialidades, // Chama a função do Firebase
              child: _carregando 
                ? const SizedBox(
                    height: 20, 
                    width: 20, 
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                  )
                : const Text(
                    "PRÓXIMO PASSO", 
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                  ),
            ),
          ),
        ],
      ),
    );
  }
}