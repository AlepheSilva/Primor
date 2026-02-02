import 'package:flutter/material.dart';
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

  // Lista de especialidades selecionadas
  final List<String> _especialidadesSelecionadas = [];

  // Mapa de Categorias e Serviços (Fácil de expandir no futuro!)
  final Map<String, List<String>> _categorias = {
    "Elétrica e Climatização": ["Eletricista", "Ar-condicionado", "Antenas/Interfones"],
    "Hidráulica e Gás": ["Encanador", "Desentupidor", "Aquecedores a Gás"],
    "Reformas e Acabamentos": ["Pintor", "Pedreiro", "Gesseiro", "Marceneiro"],
    "Serviços Gerais e Lar": ["Marido de Aluguel", "Montador de Móveis", "Jardineiro", "Limpeza"],
  };

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

                  // Gerador Automático de Categorias e Chips
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
                          spacing: 8.0, // Espaço horizontal entre chips
                          runSpacing: 4.0, // Espaço vertical entre linhas de chips
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
                  },
                )],
              ),
            ),
          ),

          // Rodapé com o botão
          // No final do build, dentro do Padding do botão:
Padding(
  padding: const EdgeInsets.all(24.0),
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 18),
      backgroundColor: azulMarinho,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    // O botão só habilita se houver especialidades selecionadas
    onPressed: _especialidadesSelecionadas.isEmpty 
      ? null 
      : () {
          // COMANDO DE NAVEGAÇÃO ADICIONADO AQUI:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CadastroPasso3(),
            ),
          );
        },
    child: const Text(
                "PRÓXIMO PASSO", 
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
              ),
            ),
          ),
        ],
      ),
    ); // Aqui fecha o Scaffold
  } // Aqui fecha o método build
} // Aqui fecha a classe _CadastroPasso2State