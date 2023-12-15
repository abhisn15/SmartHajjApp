import 'package:flutter/material.dart';

class ProgressPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255) // Warna garis progres
      ..strokeCap = StrokeCap.square
      ..strokeWidth = size.height; // Lebar garis progres

    // Gambar garis progres horizontal
    canvas.drawLine(
        Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);

    // Gambar lingkaran kecil di tengah yang lebih besar
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
