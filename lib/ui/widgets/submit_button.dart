import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback _onPressed;
  final String title;

  SubmitButton({Key? key, required this.title, required VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width, 50),
        primary: Color.fromRGBO(144, 83, 235, 1), //rgba(144, 83, 235, 1)
        onPrimary: Colors.white, //Theme.of(context).primaryColor,
        //enableFeedback: true,
        //tapTargetSize: MaterialTapTargetSize.padded,
        //animationDuration: Duration(milliseconds: 100),
        elevation: 4.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
      onPressed: _onPressed,
      child: Text(title),
    );
  }
}
