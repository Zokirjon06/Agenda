import 'package:agenda/layers/domain/auth/entity/register.dart';
import 'package:agenda/layers/domain/auth/repository/register/register_repository.dart';

class RegisterUsecase {
  final RegisterRepository repository;
  RegisterUsecase(this.repository);

  Future<bool> call(Register register) async {
    return repository.register(register);
  }
}
