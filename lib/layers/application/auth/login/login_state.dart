part of 'login_cubit.dart';

enum LoginPageStatus { initial, loading, error, success }

class LoginState extends Equatable {
  const LoginState({this.error, this.status = LoginPageStatus.initial});

  final String? error;
  final LoginPageStatus status;

  LoginState copyWith({String? error, LoginPageStatus? status}) {
    return LoginState(
      error: error ?? this.error,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [error, status];
}
