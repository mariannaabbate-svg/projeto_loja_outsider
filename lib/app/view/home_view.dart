import 'package:flutter/material.dart';

import '../data/camisa_model.dart';
import '../data/compra_model.dart';
import 'home_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewModel viewModel = HomeViewModel();

  late CamisaModel camisa;
  late String tamanhoSelecionado;
  late String corSelecionada;

  int quantidade = 1;
  bool embrulharParaPresente = false;
  int parcelasSelecionadas = 1;

  @override
  void initState() {
    super.initState();

    camisa = viewModel.buscarCamisa();

    tamanhoSelecionado = camisa.tamanhosDisponiveis.first;
    corSelecionada = camisa.modelos.first.cor;
  }

  CompraModel get compraAtual {
    return CompraModel(
      camisa: camisa,
      cor: corSelecionada,
      tamanho: tamanhoSelecionado,
      quantidade: quantidade,
      embrulharParaPresente: embrulharParaPresente,
      parcelas: parcelasSelecionadas,
    );
  }

  ModeloCamisa get modeloSelecionado {
    return camisa.modelos.firstWhere(
      (modelo) => modelo.cor == corSelecionada,
    );
  }

  String primeiraLetraMaiuscula(String texto) {
    if (texto.isEmpty) {
      return texto;
    }

    return texto[0].toUpperCase() + texto.substring(1);
  }

  String formatarMoeda(double valor) {
    return valor.toStringAsFixed(2).replaceAll('.', ',');
  }

  void diminuirQuantidade() {
    if (quantidade > 1) {
      setState(() {
        quantidade--;
      });
    }
  }

  void aumentarQuantidade() {
    setState(() {
      quantidade++;
    });
  }

  void finalizarCompra() {
    final compra = compraAtual;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Compra finalizada! Total: R\$ ${formatarMoeda(compra.total)}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final compra = compraAtual;

    const double alturaLinha = 58;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'Loja Outsider',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 360,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 40, 12, 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 145,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Selecione a Cor:',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            RadioGroup<String>(
                              groupValue: corSelecionada,
                              onChanged: (novaCor) {
                                setState(() {
                                  corSelecionada = novaCor!;
                                });
                              },
                              child: Column(
                                children: camisa.modelos.map((modelo) {
                                  return RadioListTile<String>(
                                    value: modelo.cor,
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    visualDensity: VisualDensity.compact,
                                    title: Text(
                                      primeiraLetraMaiuscula(modelo.cor),
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      SizedBox(
                        width: 145,
                        height: 145,
                        child: Image.asset(
                          modeloSelecionado.imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.image_not_supported,
                              size: 80,
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  const Divider(height: 1),

                  SizedBox(
                    height: alturaLinha,
                    child: Row(
                      children: [
                        const Text(
                          'Tamanho:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Spacer(),

                        SizedBox(
                          width: 100,
                          child: DropdownButton<String>(
                            value: tamanhoSelecionado,
                            isExpanded: true,
                            underline: const SizedBox(),
                            items: camisa.tamanhosDisponiveis.map((tamanho) {
                              return DropdownMenuItem<String>(
                                value: tamanho,
                                child: Text(tamanho),
                              );
                            }).toList(),
                            onChanged: (novoTamanho) {
                              setState(() {
                                tamanhoSelecionado = novoTamanho!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),

                  SizedBox(
                    height: alturaLinha,
                    child: Row(
                      children: [
                        const Text(
                          'Quantidade:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Spacer(),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: diminuirQuantidade,
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(
                                Icons.remove_circle_outline,
                                color: Colors.red,
                              ),
                            ),

                            const SizedBox(width: 14),

                            Text(
                              quantidade.toString(),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(width: 14),

                            IconButton(
                              onPressed: aumentarQuantidade,
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(
                                Icons.add_circle_outline,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),

                  SizedBox(
                    height: alturaLinha,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Embalar para presente? (+ R\$ ${formatarMoeda(camisa.valorPresente)})',
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),

                        Checkbox(
                          value: embrulharParaPresente,
                          activeColor: Colors.deepPurple,
                          onChanged: (novoValor) {
                            setState(() {
                              embrulharParaPresente = novoValor ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),

                  const SizedBox(height: 28),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Parcelas: $parcelasSelecionadas x',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Slider(
                    value: parcelasSelecionadas.toDouble(),
                    min: 1,
                    max: camisa.maxParcelas.toDouble(),
                    divisions: camisa.maxParcelas - 1,
                    label: '$parcelasSelecionadas x',
                    onChanged: (novoValor) {
                      setState(() {
                        parcelasSelecionadas = novoValor.round();
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Colors.blue.shade100,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Total: R\$ ${formatarMoeda(compra.total)}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '($parcelasSelecionadas x de R\$ ${formatarMoeda(compra.valorParcela)})',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: finalizarCompra,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 13,
                        ),
                      ),
                      child: const Text(
                        'Finalizar Compra',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}