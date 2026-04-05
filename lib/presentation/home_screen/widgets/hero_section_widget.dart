import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../routes/app_routes.dart';

// ─── Main Widget ────────────────────────────────────────────────────────────

class HeroSectionWidget extends StatefulWidget {
  const HeroSectionWidget({super.key});

  @override
  State<HeroSectionWidget> createState() => _HeroSectionWidgetState();
}

class _HeroSectionWidgetState extends State<HeroSectionWidget>
    with TickerProviderStateMixin {
  // Globe rotation
  late AnimationController _globeController;

  // Pulse rings
  late AnimationController _pulseController;
  late Animation<double> _pulse1;
  late Animation<double> _pulse2;
  late Animation<double> _pulse3;
  late Animation<double> _pulseOpacity1;
  late Animation<double> _pulseOpacity2;
  late Animation<double> _pulseOpacity3;

  // Blinking dot
  late AnimationController _blinkController;
  late Animation<double> _blinkAnim;

  // CTA press lift
  bool _ctaPressed = false;

  @override
  void initState() {
    super.initState();

    // Globe rotation — 18 s full turn
    _globeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();

    // Pulse rings — each ring 3 s, staggered
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _pulse1 = Tween<double>(begin: 0.8, end: 1.4).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _pulseOpacity1 = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _pulse2 = Tween<double>(begin: 0.8, end: 1.4).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: const Interval(0.33, 0.93, curve: Curves.easeOut),
      ),
    );
    _pulseOpacity2 = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: const Interval(0.33, 0.93, curve: Curves.easeOut),
      ),
    );

    _pulse3 = Tween<double>(begin: 0.8, end: 1.4).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: const Interval(0.66, 1.0, curve: Curves.easeOut),
      ),
    );
    _pulseOpacity3 = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: const Interval(0.66, 1.0, curve: Curves.easeOut),
      ),
    );

    // Blinking green dot
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _blinkAnim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _globeController.dispose();
    _pulseController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double globeSize = 130.0;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1a1a6e), Color(0xFF2d1b8a), Color(0xFF1e4d6e)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2d1b8a).withAlpha(140),
            blurRadius: 36,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: const Color(0xFF1e4d6e).withAlpha(77),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // ── Globe + pulse rings (top-right) ──────────────────────────
            Positioned(
              top: -10,
              right: -10,
              child: SizedBox(
                width: globeSize + 60,
                height: globeSize + 60,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Pulse ring 1
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (_, __) => _PulseRing(
                        scale: _pulse1.value,
                        opacity: _pulseOpacity1.value,
                        size: globeSize,
                      ),
                    ),
                    // Pulse ring 2
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (_, __) => _PulseRing(
                        scale: _pulse2.value,
                        opacity: _pulseOpacity2.value,
                        size: globeSize,
                      ),
                    ),
                    // Pulse ring 3
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (_, __) => _PulseRing(
                        scale: _pulse3.value,
                        opacity: _pulseOpacity3.value,
                        size: globeSize,
                      ),
                    ),
                    // Rotating globe
                    RotationTransition(
                      turns: _globeController,
                      child: SizedBox(
                        width: globeSize,
                        height: globeSize,
                        child: CustomPaint(painter: GlobePainter()),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Card content ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Space for globe overlap at top-right
                  const SizedBox(height: 8),

                  // 1. Live badge
                  _LiveBadge(blinkAnim: _blinkAnim),

                  const SizedBox(height: 20),

                  // 2. Gradient heading
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFFb8a0ff),
                        Color(0xFF7de8c8),
                        Color(0xFFa0d4ff),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds),
                    blendMode: BlendMode.srcIn,
                    child: Text(
                      'GlobalX — The Smartest Way to Move Money Globally',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                            height: 1.18,
                            fontSize: 24,
                            color: Colors.white,
                          ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 3. Subtitle
                  Text(
                    'Compare and optimize international transfer routes across banks, crypto, and payout networks in real time.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFFc8dff5),
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 4. Feature pills
                  Row(
                    children: const [
                      _FeaturePill(label: '130+ Currencies'),
                      SizedBox(width: 8),
                      _FeaturePill(label: '30+ Providers'),
                      SizedBox(width: 8),
                      _FeaturePill(label: 'No hidden fees'),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 5. CTA button with lift animation
                  GestureDetector(
                    onTapDown: (_) => setState(() => _ctaPressed = true),
                    onTapUp: (_) {
                      setState(() => _ctaPressed = false);
                      Navigator.pushNamed(
                        context,
                        AppRoutes.routeComparisonScreen,
                      );
                    },
                    onTapCancel: () => setState(() => _ctaPressed = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      width: double.infinity,
                      height: 52,
                      transform: Matrix4.translationValues(
                        0,
                        _ctaPressed ? 2.0 : 0.0,
                        0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: _ctaPressed
                            ? []
                            : [
                                BoxShadow(
                                  color: Colors.black.withAlpha(46),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                      ),
                      child: Center(
                        child: Text(
                          'Find Best Route →',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: const Color(0xFF2d1b8a),
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Pulse Ring ─────────────────────────────────────────────────────────────

class _PulseRing extends StatelessWidget {
  final double scale;
  final double opacity;
  final double size;

  const _PulseRing({
    required this.scale,
    required this.opacity,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF7de8c8).withAlpha(128),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Live Badge ─────────────────────────────────────────────────────────────

class _LiveBadge extends StatelessWidget {
  final Animation<double> blinkAnim;
  const _LiveBadge({required this.blinkAnim});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(31),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.white.withAlpha(46)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: blinkAnim,
            builder: (_, __) => Opacity(
              opacity: blinkAnim.value,
              child: Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Color(0xFF4ADE80),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const SizedBox(width: 7),
          Text(
            'Real-time route optimization',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white.withAlpha(230),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Feature Pill ────────────────────────────────────────────────────────────

class _FeaturePill extends StatelessWidget {
  final String label;
  const _FeaturePill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(26),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withAlpha(56)),
        ),
        child: Text(
          label,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.white.withAlpha(230),
            fontWeight: FontWeight.w600,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}

// ─── Globe Painter ───────────────────────────────────────────────────────────

class GlobePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = math.min(cx, cy) * 0.92;

    // ── 1. Filled sphere with radial gradient ──────────────────────────
    final spherePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        radius: 1.0,
        colors: const [
          Color(0xFF3a5fc8),
          Color(0xFF1a2e8a),
          Color(0xFF0d1a5c),
          Color(0xFF060e3a),
        ],
        stops: const [0.0, 0.4, 0.75, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r));

    canvas.drawCircle(Offset(cx, cy), r, spherePaint);

    // Clip all subsequent drawing to the sphere
    canvas.save();
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r)),
    );

    // ── 2. Latitude lines ──────────────────────────────────────────────
    final latPaint = Paint()
      ..color = Colors.white.withAlpha(46)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7;

    for (final t in [-0.7, -0.45, -0.2, 0.0, 0.2, 0.45, 0.7]) {
      final latY = cy + r * t;
      final latRx = r * math.sqrt(1 - t * t);
      final latRy = latRx * 0.28;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx, latY),
          width: latRx * 2,
          height: latRy * 2,
        ),
        latPaint,
      );
    }

    // ── 3. Longitude lines ─────────────────────────────────────────────
    final lonPaint = Paint()
      ..color = Colors.white.withAlpha(36)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7;

    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * math.pi;
      final dx = r * math.cos(angle);
      canvas.drawLine(
        Offset(cx - dx, cy - r),
        Offset(cx + dx, cy + r),
        lonPaint,
      );
    }

    // ── 4. City dots & connecting lines ───────────────────────────────
    // City positions (normalized -1..1 on sphere surface projected flat)
    final cities = [
      Offset(cx - r * 0.55, cy - r * 0.35), // London
      Offset(cx - r * 0.65, cy + r * 0.10), // New York
      Offset(cx + r * 0.50, cy - r * 0.20), // Dubai
      Offset(cx + r * 0.65, cy + r * 0.05), // Singapore
      Offset(cx + r * 0.30, cy - r * 0.55), // Moscow
      Offset(cx - r * 0.20, cy + r * 0.50), // São Paulo
      Offset(cx + r * 0.10, cy + r * 0.40), // Nairobi
      Offset(cx - r * 0.40, cy - r * 0.60), // Toronto
    ];

    final cityColors = [
      const Color(0xFF4ADE80), // green
      const Color(0xFF60a5fa), // blue
      const Color(0xFFfbbf24), // yellow
      const Color(0xFFf472b6), // pink
      const Color(0xFF34d399), // teal
      const Color(0xFFa78bfa), // purple
      const Color(0xFFfb923c), // orange
      const Color(0xFF38bdf8), // sky
    ];

    // Connecting lines between pairs
    final connections = [
      [0, 2], // London → Dubai
      [1, 3], // New York → Singapore
      [4, 6], // Moscow → Nairobi
      [5, 7], // São Paulo → Toronto
      [0, 1], // London → New York
      [2, 3], // Dubai → Singapore
    ];

    final lineColors = [
      const Color(0xFF4ADE80),
      const Color(0xFF60a5fa),
      const Color(0xFFfbbf24),
      const Color(0xFFf472b6),
      const Color(0xFF34d399),
      const Color(0xFFa78bfa),
    ];

    for (int i = 0; i < connections.length; i++) {
      final from = cities[connections[i][0]];
      final to = cities[connections[i][1]];
      final linePaint = Paint()
        ..color = lineColors[i].withAlpha(140)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;
      canvas.drawLine(from, to, linePaint);
    }

    // Draw city dots
    for (int i = 0; i < cities.length; i++) {
      // Outer glow
      canvas.drawCircle(
        cities[i],
        4.5,
        Paint()..color = cityColors[i].withAlpha(64),
      );
      // Core dot
      canvas.drawCircle(cities[i], 2.8, Paint()..color = cityColors[i]);
    }

    // ── 5. Glare ellipse ───────────────────────────────────────────────
    final glarePaint = Paint()
      ..shader =
          RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [Colors.white.withAlpha(77), Colors.white.withAlpha(0)],
          ).createShader(
            Rect.fromCenter(
              center: Offset(cx - r * 0.28, cy - r * 0.32),
              width: r * 0.9,
              height: r * 0.5,
            ),
          );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx - r * 0.28, cy - r * 0.32),
        width: r * 0.9,
        height: r * 0.5,
      ),
      glarePaint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
