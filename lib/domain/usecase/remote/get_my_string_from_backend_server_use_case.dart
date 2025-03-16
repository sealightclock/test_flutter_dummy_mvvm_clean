import 'package:test_flutter_dummy_mvvm_clean/data/remote/my_string_backend_server_repository.dart';

class GetMyStringFromBackendServerUseCase {
  final MyStringBackendServerRepository repository;

  GetMyStringFromBackendServerUseCase(this.repository);

  Future<String> execute() async {
    return repository.getMyStringFromServer();
  }
}
