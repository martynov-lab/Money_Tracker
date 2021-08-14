import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:money_tracker/bloc/authentication_bloc/authentication_event.dart';
import 'package:money_tracker/bloc/login_bloc/login_bloc.dart';
import 'package:money_tracker/bloc/login_bloc/login_bloc.dart';
import 'package:money_tracker/bloc/login_bloc/login_event.dart';
import 'package:money_tracker/bloc/login_bloc/login_state.dart';
import 'package:money_tracker/repository/user_repository.dart';
import 'package:money_tracker/ui/widgets/submit_button.dart';
import 'package:money_tracker/ui/widgets/google_button.dart';
import 'package:money_tracker/utils/validator.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;
  LoginForm({Key? key, required UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(
              children: [
                Text(
                  'Ошибка автаризации!',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Icon(Icons.error, color: Colors.white)
              ],
            ),
            backgroundColor: Colors.red[300],
          ));
        }
        if (state.isSubmitting) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Вход..',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                CircularProgressIndicator(),
              ],
            ),
            backgroundColor: Colors.blue[400],
          ));
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context)
              .add(AuthenticationLoggedIn());
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Form(
            //key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 40),
                  child: _input(
                      Icon(Icons.email), 'Email', _emailController, false),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _input(
                      Icon(Icons.lock), 'Password', _passwordController, true),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: SubmitButton(
                            onPressed: isLoginButtonEnabled(state)
                                ? _onFormSubmitted
                                : () {},
                            title: 'Вход',
                          ),
                        ),
                        GoogleButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _input(
      Icon icon, String hint, TextEditingController controller, bool obscure) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
        validator: (value) {
          switch (hint) {
            case "Email":
              return Validator.validateEmail(email: value.toString());
            case "Password":
              return Validator.validatePassword(password: value.toString());
            case "User Name":
              return Validator.validateName(name: value.toString());
            default:
          }
        },
        controller: controller,
        obscureText: obscure,
        style: TextStyle(fontSize: 16, color: Colors.grey),
        decoration: InputDecoration(
          hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
          hintText: hint,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(color: Colors.grey, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: IconTheme(
              data: IconThemeData(color: Colors.grey),
              child: icon,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.add(
      LoginEmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.add(
      LoginPasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
