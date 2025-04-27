import 'package:flutter/material.dart';

class ProfileActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;
  final Color? color;

  const ProfileActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final buttonColor =
        isDestructive ? colorScheme.error : color ?? colorScheme.primary;
    final containerColor = isDestructive
        ? colorScheme.errorContainer.withOpacity(0.3)
        : buttonColor.withOpacity(0.08);
    final textColor = isDestructive ? colorScheme.error : buttonColor;
    final iconColor = isDestructive ? colorScheme.error : buttonColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDestructive
                ? colorScheme.error.withOpacity(0.3)
                : buttonColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDestructive
                    ? colorScheme.error.withOpacity(0.1)
                    : buttonColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: iconColor,
            ),
          ],
        ),
      ),
    );
  }
}