import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../routes/app_routes.dart';

class SettingsAccountWidget extends StatelessWidget {
  const SettingsAccountWidget({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Sign Out'),
        content: const Text(
          'Are you sure you want to sign out of GlobalX? Your saved preferences will be retained.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.homeScreen,
                (route) => false,
              );
            },
            style: FilledButton.styleFrom(backgroundColor: AppTheme.onSurface),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Account'),
        content: const Text(
          'This will permanently delete your GlobalX account and all transfer history. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Delete Forever'),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature — coming soon'),
        backgroundColor: AppTheme.onSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(8),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'ACCOUNT',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.muted,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              _AccountRow(
                icon: Icons.privacy_tip_outlined,
                iconColor: AppTheme.primary,
                title: 'Privacy Policy',
                onTap: () => _showComingSoon(context, 'Privacy Policy'),
              ),
              const Divider(indent: 52, endIndent: 16, height: 1),
              _AccountRow(
                icon: Icons.article_outlined,
                iconColor: AppTheme.primary,
                title: 'Terms of Service',
                onTap: () => _showComingSoon(context, 'Terms of Service'),
              ),
              const Divider(indent: 52, endIndent: 16, height: 1),
              _AccountRow(
                icon: Icons.help_outline_rounded,
                iconColor: AppTheme.secondary,
                title: 'Help & Support',
                onTap: () => _showComingSoon(context, 'Help & Support'),
              ),
              const Divider(indent: 52, endIndent: 16, height: 1),
              _AccountRow(
                icon: Icons.star_outline_rounded,
                iconColor: AppTheme.cryptoAccent,
                title: 'Rate GlobalX',
                onTap: () => _showComingSoon(context, 'Rate GlobalX'),
              ),
              const Divider(indent: 52, endIndent: 16, height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 14,
                      color: AppTheme.muted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'GlobalX v1.0.0 · Build 2026.04.03',
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Danger zone
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.error.withAlpha(40)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(8),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 14,
                      color: AppTheme.error,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'DANGER ZONE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.error,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => _showLogoutDialog(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppTheme.errorContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.logout_rounded,
                          size: 18,
                          color: AppTheme.error,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sign Out',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: AppTheme.error,
                              ),
                            ),
                            Text(
                              'Sign out of your account',
                              style: theme.textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppTheme.error,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(indent: 52, endIndent: 16, height: 1),
              InkWell(
                onTap: () => _showDeleteAccountDialog(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppTheme.errorContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.delete_forever_outlined,
                          size: 18,
                          color: AppTheme.error,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Delete Account',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: AppTheme.error,
                              ),
                            ),
                            Text(
                              'Permanently remove all your data',
                              style: theme.textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppTheme.error,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ],
    );
  }
}

class _AccountRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  const _AccountRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: theme.textTheme.titleSmall)),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppTheme.muted,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
