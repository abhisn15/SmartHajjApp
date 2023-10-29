import 'package:flutter/material.dart';

class CustomInformationButton extends StatelessWidget {
  final String image;
  final String text;
  final VoidCallback onPressed;

  CustomInformationButton({
    required this.image,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.0,
      margin: const EdgeInsets.only(left: 0, top: 20.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 2),
        ),
        child: Column(
          children: <Widget>[
            Image.asset(
              image,
              width: 46,
              height: 46,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Container(
                width: 90.0,
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF2B4570),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
