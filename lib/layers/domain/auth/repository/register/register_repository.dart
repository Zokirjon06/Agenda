import 'package:agenda/layers/domain/auth/entity/register.dart';

abstract class RegisterRepository {
  Future<bool> register(Register register);
}