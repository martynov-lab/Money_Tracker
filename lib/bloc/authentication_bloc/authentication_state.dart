import 'package:equatable/equatable.dart';
import 'package:money_tracker/data/models/user.dart';

abstract class AuthenticationState extends Equatable {
  AuthenticationState();

  @override
  List<Object?> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final MyAppUser firebaseUser;

  AuthenticationSuccess(this.firebaseUser);

  @override
  List<Object?> get props => [firebaseUser];
}

class AuthenticationFailure extends AuthenticationState {}
