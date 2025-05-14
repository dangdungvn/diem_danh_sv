import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class NeonCard extends StatefulWidget {
  final Widget child;
  final double intensity;
  final double glowSpread;

  const NeonCard({
    super.key,
    required this.child,
    this.intensity = 0.3,
    this.glowSpread = 2.0,
  });

  @override
  _NeonCardState createState() => _NeonCardState();
}

class _NeonCardState extends State<NeonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: GlowRectanglePainter(
            progress: _controller.value,
            intensity: widget.intensity,
            glowSpread: widget.glowSpread,
          ),
          child: widget.child,
        );
      },
    );
  }
}

class GlowRectanglePainter extends CustomPainter {
  final double progress;
  final double intensity;
  final double glowSpread;

  GlowRectanglePainter({
    required this.progress,
    this.intensity = 0.3,
    this.glowSpread = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(20));

    // Màu sắc dựa trên theme của ứng dụng
    const primaryColor = Color(0xFF222862); // Light theme primary
    const secondaryColor = Color(0xFFF79421); // Màu cam từ theme
    const tertiaryColor = Color(0xFF403F8B); // Dark theme primary
    const blurSigma = 20.0;

    // Sử dụng 3 màu từ theme cho hiệu ứng đẹp hơn
    final color1 = Color.lerp(primaryColor, secondaryColor, progress * 0.7)!;
    final color2 = Color.lerp(secondaryColor, tertiaryColor, progress * 0.5)!;

    // Vẽ glow effect tinh tế hơn
    final backgroundPaint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(size.width / 2, size.height / 2),
        size.width * glowSpread,
        [
          color1.withOpacity(intensity * 0.7),
          color2.withOpacity(0.0),
        ],
      )
      ..maskFilter =
          MaskFilter.blur(BlurStyle.normal, blurSigma * (0.5 + progress * 0.5));

    // Vẽ hiệu ứng glow nhẹ nhàng hơn
    canvas.drawRect(
        rect.inflate(size.width * glowSpread * 0.5), backgroundPaint);

    // Không cần vẽ background màu đen
    // Viền sáng với gradient từ các màu theme
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..shader = LinearGradient(
        colors: [
          color1.withOpacity(0.7 + progress * 0.3),
          color2.withOpacity(0.7 + progress * 0.3),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);
    canvas.drawRRect(rrect, glowPaint);
  }

  @override
  bool shouldRepaint(GlowRectanglePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.intensity != intensity ||
      oldDelegate.glowSpread != glowSpread;
}

class GradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  final List<Color> gradientColors;

  const GradientText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: gradientColors,
          stops: const [0.0, 0.5, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          height: 0.9,
          letterSpacing: -0.5,
          shadows: [
            Shadow(
              color: gradientColors[0].withOpacity(0.3),
              offset: const Offset(0, 1),
              blurRadius: 3,
            ),
          ],
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}
