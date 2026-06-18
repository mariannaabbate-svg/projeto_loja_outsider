import 'dart:convert';

import 'camisa_model.dart';
import 'camisa_service.dart';

class CamisaRepository {
  final CamisaService _service = CamisaService();

  CamisaModel buscarCamisa() {
    final String resposta = _service.buscarCamisa();

    final Map<String, dynamic> map = jsonDecode(resposta);

    return CamisaModel.fromMap(map);
  }
}