import 'package:money_tracker/bloc/register_bloc/register_event.dart';
import 'package:money_tracker/bloc/register_bloc/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/data/repository/user_repository.dart';
import 'package:money_tracker/utils/validator.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;

  RegisterBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(RegisterState.initial());

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterEmailChanged) {
      yield* _mapRegisterEmailChangeToState(event.email);
    } else if (event is RegisterPasswordChanged) {
      yield* _mapRegisterPasswordChangeToState(event.password);
    } else if (event is RegisterSubmitted) {
      yield* _mapRegisterSubmittedToState(
          email: event.email, password: event.password, name: event.password);
    }
  }

  Stream<RegisterState> _mapRegisterEmailChangeToState(String email) async* {
    yield state.updateEmail(isEmailValid: Validator.isValidEmail(email));
  }

  Stream<RegisterState> _mapRegisterPasswordChangeToState(
      String password) async* {
    yield state.updatePassword(
        isPasswordValid: Validator.isValidPassword(password));
  }

  Stream<RegisterState> _mapRegisterSubmittedToState(
      {required String email,
      required String password,
      required String name}) async* {
    yield RegisterState.loading();
    try {
      await _userRepository.signUp(
          email: email, password: password, name: name);
      yield RegisterState.success();
    } catch (error) {
      yield RegisterState.failure();
    }
  }
}
