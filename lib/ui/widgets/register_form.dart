import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:money_tracker/bloc/authentication_bloc/authentication_event.dart';
import 'package:money_tracker/bloc/register_bloc/register_bloc.dart';
import 'package:money_tracker/bloc/register_bloc/register_event.dart';
import 'package:money_tracker/bloc/register_bloc/register_state.dart';
import 'package:money_tracker/ui/widgets/google_button.dart';
import 'package:money_tracker/ui/widgets/submit_button.dart';
import 'package:money_tracker/utils/validator.dart';

class RegisterForm extends StatefulWidget {
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late RegisterBloc _registerBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _nameController.addListener(_onNameChanged);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(
              children: [
                Text(
                  'Ошибка регистрации!',
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
                  'Регистраци пользователя..',
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
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return Form(
            //key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 20),
                  child: _input(
                      Icon(Icons.person), 'Name', _nameController, false),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _input(
                      Icon(Icons.email), 'Email', _emailController, false),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _input(
                      Icon(Icons.lock), 'Password', _passwordController, true),
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
                            onPressed: isRegisterButtonEnabled(state)
                                ? _onFormSubmitted
                                : () {},
                            title: 'Регистрация',
                          ),
                        ),
                        //GoogleButton(),
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

  void _onNameChanged() {
    _registerBloc.add(
      RegisterNameChanged(name: _nameController.text),
    );
  }

  void _onEmailChanged() {
    _registerBloc.add(
      RegisterEmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _registerBloc.add(
      RegisterPasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _registerBloc.add(
      RegisterSubmitted(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
