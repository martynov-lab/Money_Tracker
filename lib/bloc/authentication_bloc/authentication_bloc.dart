import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/repository/user_repository.dart';

import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AuthenticationStarted) {
      yield* _mapAuthenticationStartedToState();
    } else if (event is AuthenticationLoggedIn) {
      yield* _mapAuthenticationLogginInToState();
    } else if (event is AuthenticationLoggedOut) {
      yield* _mapAuthenticationLogginOutToState();
    }
  }

  //AuthenticationStarted
  Stream<AuthenticationState> _mapAuthenticationStartedToState() async* {
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        final firebaseUser = await _userRepository.fetchCurrentUser();
        yield AuthenticationSuccess(firebaseUser);
      } else {
        yield AuthenticationFailure();
      }
    } catch (_) {
      yield AuthenticationFailure();
    }
  }

  //AuthenticationLoggedIn
  Stream<AuthenticationState> _mapAuthenticationLogginInToState() async* {
    final firebaseUser = await _userRepository.fetchCurrentUser();
    yield AuthenticationSuccess(firebaseUser);
  }

  //AuthenticationLoggedOut
  Stream<AuthenticationState> _mapAuthenticationLogginOutToState() async* {
    yield AuthenticationFailure();
    await _userRepository.signOut();
  }
}
