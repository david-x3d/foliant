import 'package:flutter/material.dart';

class ExpressiveHero extends StatelessWidget {
  const ExpressiveHero({
    required this.title,
    this.subtitle,
    this.trailing,
    this.titleStyle,
    this.titleMaxLines,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final TextStyle? titleStyle;
  final int? titleMaxLines;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 28, 20, 24),
      decoration: ShapeDecoration(
        color: scheme.surfaceContainerLow,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(42),
            bottomLeft: Radius.circular(42),
            bottomRight: Radius.circular(18),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: titleMaxLines,
                  style: titleStyle ?? Theme.of(context).textTheme.headlineLarge,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 10),
                  Text(subtitle!, style: Theme.of(context).textTheme.bodyLarge),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 12), trailing!],
        ],
      ),
    );
  }
}

class ChoiceTile extends StatelessWidget {
  const ChoiceTile({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutBack,
      decoration: ShapeDecoration(
        color: selected
            ? scheme.secondaryContainer
            : scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: selected
              ? BorderRadius.circular(44)
              : const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(14),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(34),
                ),
        ),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                  ],
                ),
              ),
              if (selected) const Icon(Icons.check_circle_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
