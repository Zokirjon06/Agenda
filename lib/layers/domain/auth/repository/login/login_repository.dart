import 'package:agenda/layers/domain/auth/entity/login.dart';

abstract class LoginRepository {
  Future<bool> login(Login login);
}