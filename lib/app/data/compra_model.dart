import 'camisa_model.dart';

class CompraModel {
  final CamisaModel camisa;
  final String cor;
  final String tamanho;
  final int quantidade;
  final bool embrulharParaPresente;
  final int parcelas;

  const CompraModel({
    required this.camisa,
    required this.cor,
    required this.tamanho,
    required this.quantidade,
    required this.embrulharParaPresente,
    required this.parcelas,
  });

  ModeloCamisa get modeloSelecionado {
    return camisa.modelos.firstWhere(
      (modelo) => modelo.cor == cor,
    );
  }

  double get precoUnitario {
    return modeloSelecionado.preco;
  }

  double get subtotalProdutos {
    return precoUnitario * quantidade;
  }

  double get valorEmbrulho {
    if (embrulharParaPresente) {
      return camisa.valorPresente;
    }

    return 0.0;
  }

  double get subtotal {
    return subtotalProdutos + valorEmbrulho;
  }

  double get valorJuros {
    if (parcelas <= 1) {
      return 0.0;
    }

    return subtotal * camisa.jurosPorParcela * parcelas;
  }

  double get total {
    return subtotal + valorJuros;
  }

  double get valorParcela {
    return total / parcelas;
  }

  String get descricaoPresente {
    if (embrulharParaPresente) {
      return 'Sim';
    }

    return 'Não';
  }

  @override
  String toString() {
    return '''
CompraModel(
  cor: $cor,
  tamanho: $tamanho,
  quantidade: $quantidade,
  embrulharParaPresente: $embrulharParaPresente,
  parcelas: $parcelas,
  precoUnitario: R\$ ${precoUnitario.toStringAsFixed(2)},
  subtotalProdutos: R\$ ${subtotalProdutos.toStringAsFixed(2)},
  valorEmbrulho: R\$ ${valorEmbrulho.toStringAsFixed(2)},
  valorJuros: R\$ ${valorJuros.toStringAsFixed(2)},
  total: R\$ ${total.toStringAsFixed(2)},
  valorParcela: R\$ ${valorParcela.toStringAsFixed(2)}
)
''';
  }
}