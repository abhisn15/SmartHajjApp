import 'package:flutter/material.dart';

class ProgressPainter extends CustomPainter {
  final yellow = Color.fromRGBO(223, 136, 14, 1);
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.green // Warna garis progres
      ..strokeCap = StrokeCap.square
      ..strokeWidth = size.height; // Lebar garis progres

    // Gambar garis progres horizontal
    canvas.drawLine(
        Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);

    // Gambar lingkaran kecil di tengah yang lebih besar
    final circleRadius = size.height * 2; // Ukuran lingkaran lebih besar
    paint.color = yellow; // Warna lingkaran
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), circleRadius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
