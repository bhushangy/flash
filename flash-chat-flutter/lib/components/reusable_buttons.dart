import 'package:flutter/material.dart';


class reusableButtons extends StatelessWidget {

  final Color colour;
  final String txt;
  final Function onPressed;

  reusableButtons({@required this.colour,@required this.txt,@required this.onPressed});

@override
Widget build(BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.02),
    child: Material(
      elevation: 5.0,
      color: colour,
      borderRadius: BorderRadius.circular(30.0),
      child: MaterialButton(
        onPressed:  onPressed,
        child: Text(
         txt,
          style: TextStyle(
            color: Colors.white,
                fontSize: MediaQuery.of(context).size.width*0.042,
          ),
        ),
      ),
    ),
  );
}
}
