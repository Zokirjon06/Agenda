import 'package:agenda/layers/domain/auth/entity/login.dart';
import 'package:agenda/layers/domain/auth/repository/login/login_repository.dart';

class LoginUsecase {
  final LoginRepository repository;
  LoginUsecase(this.repository);

  Future<bool> call(Login login) async {
    return repository.login(login);
  }
}