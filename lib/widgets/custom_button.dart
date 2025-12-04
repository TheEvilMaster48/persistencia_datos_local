import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;
  final Gradient? gradient;
  final bool isOutline;
  final Color? color;

  const CustomButton({
    super.key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.gradient,
    this.isOutline = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutline) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon, size: 18) : const SizedBox.shrink(),
        label: Text(text),
        style: OutlinedButton.styleFrom(
          foregroundColor: color ?? Colors.deepPurple,
          side: BorderSide(
            color: color ?? Colors.deepPurple,
            width: 2,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: gradient ??
            const LinearGradient(
              colors: [Color(0xFF7c3aed), Color(0xFF4f46e5)],
            ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon != null
            ? Icon(icon, size: 18)
            : const SizedBox.shrink(),
        label: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
