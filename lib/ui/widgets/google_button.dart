import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_tracker/bloc/login_bloc/login_bloc.dart';
import 'package:money_tracker/bloc/login_bloc/login_event.dart';

class GoogleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width, 50),
        primary: Color.fromRGBO(144, 83, 235, 1), //rgba(144, 83, 235, 1)
        onPrimary: Colors.white, //Theme.of(context).primaryColor,
        enableFeedback: true,
        tapTargetSize: MaterialTapTargetSize.padded,
        animationDuration: Duration(milliseconds: 100),
        elevation: 4.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
      icon: Icon(FontAwesomeIcons.google, color: Colors.white),
      onPressed: () {
        BlocProvider.of<LoginBloc>(context).add(
          LoginWithGooglePressed(),
        );
      },
      label: Text('Sign in with Google', style: TextStyle(color: Colors.white)),
      //color: Colors.redAccent,
    );
  }
}
