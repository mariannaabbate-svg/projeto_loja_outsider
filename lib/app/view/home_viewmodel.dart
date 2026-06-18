import '../data/camisa_model.dart';
import '../data/camisa_repository.dart';

class HomeViewModel {
  final CamisaRepository _repository = CamisaRepository();

  CamisaModel buscarCamisa() {
    return _repository.buscarCamisa();
  }
}