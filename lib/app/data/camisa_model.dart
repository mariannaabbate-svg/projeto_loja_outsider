class CamisaModel {
  final double precoBase;
  final double valorPresente;
  final int maxParcelas;
  final double jurosPorParcela;
  final List<String> tamanhosDisponiveis;
  final List<ModeloCamisa> modelos;

  CamisaModel({
    required this.precoBase,
    required this.valorPresente,
    required this.maxParcelas,
    required this.jurosPorParcela,
    required this.tamanhosDisponiveis,
    required this.modelos,
  });

  factory CamisaModel.fromMap(Map<String, dynamic> map) {
    return CamisaModel(
      precoBase: map['precoBase'] ?? 0.0,
      valorPresente: map['valorPresente'] ?? 0.0,
      maxParcelas: map['maxParcelas'] ?? 1,
      jurosPorParcela: map['jurosPorParcela'] ?? 0.0,
      tamanhosDisponiveis: List<String>.from(
        map['tamanhosDisponiveis'] ?? [],
      ),
      modelos: List<ModeloCamisa>.from(
        (map['modelos'] ?? []).map(
          (modelo) => ModeloCamisa.fromMap(modelo),
        ),
      ),
    );
  }

  @override
  String toString() {
    return 'CamisaModel(precoBase: $precoBase, valorPresente: $valorPresente, maxParcelas: $maxParcelas, jurosPorParcela: $jurosPorParcela, tamanhosDisponiveis: $tamanhosDisponiveis, modelos: $modelos)';
  }
}

class ModeloCamisa {
  final String cor;
  final String imagePath;

  ModeloCamisa({
    required this.cor,
    required this.imagePath,
  });

  factory ModeloCamisa.fromMap(Map<String, dynamic> map) {
    return ModeloCamisa(
      cor: map['cor'] ?? '',
      imagePath: map['imagePath'] ?? '',
    );
  }

  @override
  String toString() {
    return 'ModeloCamisa(cor: $cor, imagePath: $imagePath)';
  }
}