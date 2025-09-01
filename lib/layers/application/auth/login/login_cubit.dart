import 'package:agenda/layers/domain/auth/entity/login.dart';
import 'package:agenda/layers/domain/auth/usecase/login_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required LoginUsecase loginUsecase})
      : _loginUsecase = loginUsecase,
        super(const LoginState());

  final LoginUsecase _loginUsecase;

  Future<void> login(Login login) async {
    emit(state.copyWith(status: LoginPageStatus.loading));

    final result = await _loginUsecase(login);

    // result.fol

    if (result) {
      emit(state.copyWith(status: LoginPageStatus.success));
    } else {
      emit(state.copyWith(
          status: LoginPageStatus.error,
          error: 'Login failed. Please check your credentials.'));
    }
  }
}
