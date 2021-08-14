import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:money_tracker/bloc/authentication_bloc/authentication_event.dart';
import 'package:money_tracker/bloc/authentication_bloc/authentication_state.dart';
import 'package:money_tracker/bloc/simple_bloc_observer.dart';
import 'package:money_tracker/repository/user_repository.dart';
import 'package:money_tracker/ui/pages/home_page.dart';
import 'package:money_tracker/ui/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  final UserRepository userRepository = UserRepository();
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(userRepository: userRepository)
        ..add(AuthenticationStarted()),
      child: App(userRepository: userRepository),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository _userRepository;

  App({Key? key, required UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo list',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: TextTheme(
              headline1: TextStyle(color: Colors.grey),
              bodyText1: TextStyle(color: Colors.grey)),
          unselectedWidgetColor: Colors.grey),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationFailure) {
            return LoginPage(userRepository: _userRepository);
          }
          if (state is AuthenticationInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is AuthenticationSuccess) {
            return HomePage(
              user: state.firebaseUser,
            );
          }
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text('Loading...'),
            ),
          );
        },
      ),
    );
  }
}
