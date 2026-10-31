import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Glifo de Asistly: una "A" que emite ondas de señal (BLE).
/// Traducción directa del SVG del splash de Stitch (viewBox 100x100).
class AsistlyGlyph extends StatelessWidget {
  const AsistlyGlyph({super.key, this.size = 80, this.pulse});

  final double size;

  /// Valor 0..1 para animar el punto central (opcional).
  final Animation<double>? pulse;

  @override
  Widget build(BuildContext context) {
    final painter = pulse == null
        ? CustomPaint(size: Size.square(size), painter: _GlyphPainter(0))
        : AnimatedBuilder(
            animation: pulse!,
            builder: (_, _) =>
                CustomPaint(size: Size.square(size), painter: _GlyphPainter(pulse!.value)),
          );
    return painter;
  }
}

class _GlyphPainter extends CustomPainter {
  _GlyphPainter(this.pulse);

  final double pulse;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 100, size.height / 100);

    Paint stroke(Color color, double width, [double opacity = 1]) => Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // "A": trazo izquierdo y travesaño.
    canvas.drawPath(
      Path()
        ..moveTo(26, 78)
        ..lineTo(46, 22)
        ..lineTo(54, 22)
        ..lineTo(54, 44),
      stroke(Colors.white, 7),
    );
    canvas.drawLine(const Offset(34, 58), const Offset(58, 58), stroke(Colors.white, 6.5));

    // Punto focal con pulso.
    const center = Offset(58, 58);
    if (pulse > 0) {
      canvas.drawCircle(
        center,
        4.5 + 8 * pulse,
        Paint()..color = AppColors.tertiaryFixedDim.withValues(alpha: 0.6 * (1 - pulse)),
      );
    }
    canvas.drawCircle(center, 4.5, Paint()..color = AppColors.tertiaryFixedDim);

    // Tres arcos de señal.
    canvas.drawPath(
      Path()
        ..moveTo(68, 48)
        ..cubicTo(72, 52, 74, 55, 74, 58)
        ..cubicTo(74, 61, 72, 64, 68, 68),
      stroke(Colors.white, 4.5, 0.95),
    );
    canvas.drawPath(
      Path()
        ..moveTo(77, 39)
        ..cubicTo(83, 45, 86, 51, 86, 58)
        ..cubicTo(86, 65, 83, 71, 77, 77),
      stroke(AppColors.primaryFixed, 4, 0.8),
    );
    canvas.drawPath(
      Path()
        ..moveTo(86, 30)
        ..cubicTo(94, 38, 98, 47, 98, 58)
        ..cubicTo(98, 69, 94, 78, 86, 86),
      stroke(AppColors.primaryFixed, 3.5, 0.5),
    );
  }

  @override
  bool shouldRepaint(_GlyphPainter old) => old.pulse != pulse;
}
