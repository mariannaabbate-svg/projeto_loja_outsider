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

  String get textoEmbalagemPresente {
    return embrulharParaPresente
        ? 'Embalagem adicionada ao pedido'
        : 'Adicionar embalagem por R\$ ${formatarMoeda(camisa.valorPresente)}';
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

  void alterarEmbalagemPresente() {
    setState(() {
      embrulharParaPresente = !embrulharParaPresente;
    });
  }

  Widget linhaResumo(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget linhaCalculo(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void finalizarCompra() {
    final compra = compraAtual;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Resumo da compra',
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.shopping_bag,
                color: Colors.blue,
                size: 42,
              ),

              const SizedBox(height: 12),

              linhaResumo(
                'Cor:',
                primeiraLetraMaiuscula(compra.cor),
              ),
              linhaResumo(
                'Tamanho:',
                compra.tamanho,
              ),
              linhaResumo(
                'Quantidade:',
                compra.quantidade.toString(),
              ),
              linhaResumo(
                'Presente:',
                compra.embrulharParaPresente ? 'Sim' : 'Não',
              ),
              linhaResumo(
                'Parcelas:',
                '${compra.parcelas}x',
              ),

              const Divider(height: 24),

              linhaResumo(
                'Subtotal:',
                'R\$ ${formatarMoeda(compra.subtotalProdutos)}',
              ),
              linhaResumo(
                'Embalagem:',
                'R\$ ${formatarMoeda(compra.valorEmbrulho)}',
              ),
              linhaResumo(
                'Juros:',
                'R\$ ${formatarMoeda(compra.valorJuros)}',
              ),

              const Divider(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'R\$ ${formatarMoeda(compra.total)}',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Text(
                '${compra.parcelas}x de R\$ ${formatarMoeda(compra.valorParcela)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Fechar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Compra confirmada com sucesso!'),
                  ),
                );
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final compra = compraAtual;

    const double alturaLinha = 46;

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
              padding: const EdgeInsets.fromLTRB(12, 28, 12, 8),
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
                            const SizedBox(height: 2),
                            RadioGroup<String>(
                              groupValue: corSelecionada,
                              onChanged: (novaCor) {
                                setState(() {
                                  corSelecionada = novaCor!;
                                });
                              },
                              child: Column(
                                children: camisa.modelos.map((modelo) {
                                  return SizedBox(
                                    height: 30,
                                    child: RadioListTile<String>(
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
                        width: 130,
                        height: 130,
                        child: Image.asset(
                          modeloSelecionado.imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.image_not_supported,
                              size: 70,
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

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
                          width: 90,
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

                  const Divider(height: 12),

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

                            const SizedBox(width: 12),

                            Text(
                              quantidade.toString(),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(width: 12),

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

                  const SizedBox(height: 20),

                  InkWell(
                    onTap: alterarEmbalagemPresente,
                    borderRadius: BorderRadius.circular(8),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: embrulharParaPresente
                            ? Colors.blue.shade50
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: embrulharParaPresente
                              ? Colors.blue
                              : Colors.grey.shade300,
                          width: 1.3,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: embrulharParaPresente
                                  ? Colors.blue
                                  : Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.card_giftcard,
                              color: embrulharParaPresente
                                  ? Colors.white
                                  : Colors.grey.shade600,
                              size: 18,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Embalar para presente',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  textoEmbalagemPresente,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: embrulharParaPresente
                                        ? Colors.blue
                                        : Colors.black54,
                                    fontWeight: embrulharParaPresente
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Transform.scale(
                            scale: 0.82,
                            child: Switch(
                              value: embrulharParaPresente,
                              activeThumbColor: Colors.white,
                              activeTrackColor: Colors.blue,
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Colors.grey.shade400,
                              thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                                (states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return const Icon(
                                      Icons.redeem,
                                      color: Colors.blue,
                                      size: 15,
                                    );
                                  }

                                  return const Icon(
                                    Icons.redeem,
                                    color: Colors.grey,
                                    size: 15,
                                  );
                                },
                              ),
                              onChanged: (novoValor) {
                                setState(() {
                                  embrulharParaPresente = novoValor;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

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

                  SizedBox(
                    height: 32,
                    child: Slider(
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
                  ),

                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.blue.shade100,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detalhes do cálculo',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        linhaCalculo(
                          'Subtotal (produtos)',
                          'R\$ ${formatarMoeda(compra.subtotalProdutos)}',
                        ),
                        linhaCalculo(
                          'Embalagem',
                          'R\$ ${formatarMoeda(compra.valorEmbrulho)}',
                        ),
                        linhaCalculo(
                          'Juros (${compra.parcelas}x)',
                          'R\$ ${formatarMoeda(compra.valorJuros)}',
                        ),

                        const Divider(height: 18),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'R\$ ${formatarMoeda(compra.total)}',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${compra.parcelas}x de R\$ ${formatarMoeda(compra.valorParcela)}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: finalizarCompra,
                      icon: const Icon(Icons.shopping_cart),
                      label: Text(
                        'Finalizar Compra - R\$ ${formatarMoeda(compra.total)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
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