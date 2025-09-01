import 'package:agenda/layers/domain/auth/entity/register.dart';
import 'package:agenda/layers/domain/auth/usecase/register_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({required RegisterUsecase registerUsecase})
      : _registerUsecase = registerUsecase,
        super(const RegisterState());
  final RegisterUsecase _registerUsecase;

  Future<void> register(Register register) async {
    emit(state.copyWith(status: RegisterPageStatus.loading));

    final result = await _registerUsecase(register);
    if (result) {
      emit(state.copyWith(status: RegisterPageStatus.success));
    } else {
      emit(state.copyWith(
          status: RegisterPageStatus.error,
          error: 'Registration failed. Please try again.'));
    }
  }
}
