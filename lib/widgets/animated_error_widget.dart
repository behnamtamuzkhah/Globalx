import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum ErrorType { network, noResults, timeout, generic, permission }

class AnimatedErrorWidget extends StatefulWidget {
  final ErrorType errorType;
  final String? title;
  final String? message;
  final String? statusMessage;
  final VoidCallback? onRetry;
  final String? retryLabel;
  final VoidCallback? onSecondaryAction;
  final String? secondaryActionLabel;
  final bool showRetry;

  const AnimatedErrorWidget({
    super.key,
    this.errorType = ErrorType.generic,
    this.title,
    this.message,
    this.statusMessage,
    this.onRetry,
    this.retryLabel,
    this.onSecondaryAction,
    this.secondaryActionLabel,
    this.showRetry = true,
  });

  @override
  State<AnimatedErrorWidget> createState() => _AnimatedErrorWidgetState();
}

class _AnimatedErrorWidgetState extends State<AnimatedErrorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<Offset> _slideAnim;
  bool _isRetrying = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
    );

    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.75, curve: Curves.elasticOut),
      ),
    );

    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.15, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _ErrorConfig get _config {
    switch (widget.errorType) {
      case ErrorType.network:
        return _ErrorConfig(
          icon: Icons.wifi_off_rounded,
          iconColor: AppTheme.warning,
          iconBg: AppTheme.warningContainer,
          defaultTitle: 'No internet connection',
          defaultMessage:
              'Check your connection and try again. Your data will load once you\'re back online.',
          defaultRetryLabel: 'Try again',
          statusLabel: 'Network error',
        );
      case ErrorType.noResults:
        return _ErrorConfig(
          icon: Icons.search_off_rounded,
          iconColor: AppTheme.muted,
          iconBg: AppTheme.surfaceVariant,
          defaultTitle: 'No results found',
          defaultMessage:
              'We couldn\'t find anything matching your search. Try different keywords or filters.',
          defaultRetryLabel: 'Clear filters',
          statusLabel: 'No matches',
        );
      case ErrorType.timeout:
        return _ErrorConfig(
          icon: Icons.timer_off_outlined,
          iconColor: AppTheme.warning,
          iconBg: AppTheme.warningContainer,
          defaultTitle: 'Request timed out',
          defaultMessage:
              'The server took too long to respond. Please try again in a moment.',
          defaultRetryLabel: 'Retry',
          statusLabel: 'Timeout',
        );
      case ErrorType.permission:
        return _ErrorConfig(
          icon: Icons.lock_outline_rounded,
          iconColor: AppTheme.error,
          iconBg: AppTheme.errorContainer,
          defaultTitle: 'Access restricted',
          defaultMessage:
              'You don\'t have permission to view this content. Contact support if you think this is a mistake.',
          defaultRetryLabel: 'Go back',
          statusLabel: 'Permission denied',
        );
      case ErrorType.generic:
      default:
        return _ErrorConfig(
          icon: Icons.error_outline_rounded,
          iconColor: AppTheme.error,
          iconBg: AppTheme.errorContainer,
          defaultTitle: 'Something went wrong',
          defaultMessage:
              'An unexpected error occurred. Please try again or contact support if the issue persists.',
          defaultRetryLabel: 'Try again',
          statusLabel: 'Error',
        );
    }
  }

  Future<void> _handleRetry() async {
    if (_isRetrying || widget.onRetry == null) return;
    setState(() => _isRetrying = true);
    // Brief visual feedback before calling retry
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() => _isRetrying = false);
      widget.onRetry!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cfg = _config;
    final title = widget.title ?? cfg.defaultTitle;
    final message = widget.message ?? cfg.defaultMessage;
    final retryLabel = widget.retryLabel ?? cfg.defaultRetryLabel;
    final statusMsg = widget.statusMessage ?? cfg.statusLabel;

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
                // Animated icon
                ScaleTransition(
                  scale: _scaleAnim,
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: cfg.iconBg,
                      borderRadius: BorderRadius.circular(24.0),
                      boxShadow: [
                        BoxShadow(
                          color: cfg.iconColor.withAlpha(40),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(cfg.icon, size: 44, color: cfg.iconColor),
                  ),
                ),
                const SizedBox(height: 24),

                // Status chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: cfg.iconBg,
                    borderRadius: BorderRadius.circular(100.0),
                    border: Border.all(color: cfg.iconColor.withAlpha(60)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: cfg.iconColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        statusMsg,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: cfg.iconColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                // Message
                Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.muted,
                    height: 1.55,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Retry button
                if (widget.showRetry && widget.onRetry != null)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _isRetrying
                        ? Container(
                            key: const ValueKey('loading'),
                            height: 48,
                            width: 48,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryContainer,
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppTheme.primary,
                            ),
                          )
                        : FilledButton.icon(
                            key: const ValueKey('retry'),
                            onPressed: _handleRetry,
                            icon: const Icon(Icons.refresh_rounded, size: 18),
                            label: Text(retryLabel),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                            ),
                          ),
                  ),

                // Secondary action
                if (widget.onSecondaryAction != null &&
                    widget.secondaryActionLabel != null) ...[
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: widget.onSecondaryAction,
                    child: Text(
                      widget.secondaryActionLabel!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
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

class _ErrorConfig {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String defaultTitle;
  final String defaultMessage;
  final String defaultRetryLabel;
  final String statusLabel;

  const _ErrorConfig({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.defaultTitle,
    required this.defaultMessage,
    required this.defaultRetryLabel,
    required this.statusLabel,
  });
}
