part of 'register_cubit.dart';

enum RegisterPageStatus { initial, loading, error, success }

class RegisterState extends Equatable {
  const RegisterState(
      {this.error = '', this.status = RegisterPageStatus.initial});
  final String error;
  final RegisterPageStatus status;

  RegisterState copyWith({String? error, RegisterPageStatus? status}) {
    return RegisterState(
        error: error ?? this.error, status: status ?? this.status);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [error, status];
}
