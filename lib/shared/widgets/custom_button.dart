import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum ButtonType { primary, secondary, outlined, danger }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool isLoading;
  final double? width;
  final double height;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.width,
    this.height = 50,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    BorderSide? border;

    switch (type) {
      case ButtonType.primary:
        bg = AppColors.seaGreen;
        fg = AppColors.white;
        border = null;
        break;
      case ButtonType.secondary:
        bg = AppColors.celadon;
        fg = AppColors.pineTeal;
        border = null;
        break;
      case ButtonType.outlined:
        bg = Colors.transparent;
        fg = AppColors.seaGreen;
        border = const BorderSide(color: AppColors.mintLeaf2, width: 1.5);
        break;
      case ButtonType.danger:
        bg = AppColors.redDestructive;
        fg = AppColors.white;
        border = null;
        break;
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Material(
        color: onPressed == null ? bg.withOpacity(0.5) : bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: border ?? BorderSide.none,
        ),
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading) ...[
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: fg,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Please wait...',
                    style: TextStyle(
                      color: fg,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ] else ...[
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: fg),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      color: fg,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (trailingIcon != null) ...[
                    const SizedBox(width: 8),
                    Icon(trailingIcon, size: 20, color: fg),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
