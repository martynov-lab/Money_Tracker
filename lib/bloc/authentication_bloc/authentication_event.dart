import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
  @override
  List<Object> get props => [];
}

class AuthenticationStarted extends AuthenticationEvent {}

class AuthenticationLoggedIn extends AuthenticationEvent {}

class AuthenticationUpdate extends AuthenticationEvent {
  final File imageUrl;
  const AuthenticationUpdate({required this.imageUrl});

  @override
  List<Object> get props => [imageUrl];
}

class AuthenticationLoggedOut extends AuthenticationEvent {}
