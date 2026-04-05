import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnimatedEmptyStateWidget extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? ctaLabel;
  final VoidCallback? onCta;
  final IconData? ctaIcon;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final String? statusMessage;

  const AnimatedEmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.ctaLabel,
    this.onCta,
    this.ctaIcon,
    this.iconColor,
    this.iconBackgroundColor,
    this.statusMessage,
  });

  @override
  State<AnimatedEmptyStateWidget> createState() =>
      _AnimatedEmptyStateWidgetState();
}

class _AnimatedEmptyStateWidgetState extends State<AnimatedEmptyStateWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _scaleAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _bounceAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconBg = widget.iconBackgroundColor ?? AppTheme.surfaceVariant;
    final iconColor = widget.iconColor ?? AppTheme.muted;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated icon container
                ScaleTransition(
                  scale: _scaleAnim,
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(24.0),
                      boxShadow: [
                        BoxShadow(
                          color: iconColor.withAlpha(30),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(widget.icon, size: 44, color: iconColor),
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                AnimatedBuilder(
                  animation: _bounceAnim,
                  builder: (context, child) => Opacity(
                    opacity: _bounceAnim.value.clamp(0.0, 1.0),
                    child: child,
                  ),
                  child: Text(
                    widget.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),

                // Description
                AnimatedBuilder(
                  animation: _bounceAnim,
                  builder: (context, child) => Opacity(
                    opacity: (_bounceAnim.value - 0.1).clamp(0.0, 1.0),
                    child: child,
                  ),
                  child: Text(
                    widget.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.muted,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // Status message chip
                if (widget.statusMessage != null) ...[
                  const SizedBox(height: 14),
                  AnimatedBuilder(
                    animation: _bounceAnim,
                    builder: (context, child) => Opacity(
                      opacity: (_bounceAnim.value - 0.2).clamp(0.0, 1.0),
                      child: child,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(100.0),
                        border: Border.all(color: AppTheme.outlineVariant),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 13,
                            color: AppTheme.muted,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.statusMessage!,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppTheme.muted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                // CTA button
                if (widget.ctaLabel != null && widget.onCta != null) ...[
                  const SizedBox(height: 28),
                  AnimatedBuilder(
                    animation: _bounceAnim,
                    builder: (context, child) => Opacity(
                      opacity: (_bounceAnim.value - 0.3).clamp(0.0, 1.0),
                      child: Transform.translate(
                        offset: Offset(
                          0,
                          10 * (1 - (_bounceAnim.value - 0.3).clamp(0.0, 1.0)),
                        ),
                        child: child,
                      ),
                    ),
                    child: FilledButton.icon(
                      onPressed: widget.onCta,
                      icon: Icon(
                        widget.ctaIcon ?? Icons.arrow_forward_rounded,
                        size: 18,
                      ),
                      label: Text(widget.ctaLabel!),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
