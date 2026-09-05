import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum BadgeStatus {
  verified,
  skillVerified,
  coopVerified,
  identityVerified,
  backgroundChecked,
  experienced,
  highlyRated,
  teamBooking,
  active,
  pending,
  rejected,
  suspended,
  completed,
  onTheWay,
  inProgress,
  emergency,
  coopOwner,
}

class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeStatus status;
  final IconData? icon;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const StatusBadge({
    super.key,
    required this.label,
    required this.status,
    this.icon,
    this.fontSize = 11,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData? defaultIcon = icon;

    switch (status) {
      case BadgeStatus.verified:
      case BadgeStatus.skillVerified:
      case BadgeStatus.coopVerified:
      case BadgeStatus.identityVerified:
        bg = AppColors.mintLeaf2.withOpacity(0.2);
        fg = AppColors.darkEmerald;
        defaultIcon ??= Icons.verified;
        break;
      case BadgeStatus.backgroundChecked:
        bg = AppColors.frostedMint;
        fg = AppColors.darkEmerald;
        defaultIcon ??= Icons.security;
        break;
      case BadgeStatus.experienced:
      case BadgeStatus.highlyRated:
        bg = const Color(0xFFFFF3CD);
        fg = const Color(0xFF856404);
        defaultIcon ??= Icons.star;
        break;
      case BadgeStatus.teamBooking:
        bg = AppColors.pineTeal.withOpacity(0.12);
        fg = AppColors.pineTeal;
        defaultIcon ??= Icons.groups;
        break;
      case BadgeStatus.active:
        bg = AppColors.celadon;
        fg = AppColors.pineTeal;
        defaultIcon ??= Icons.check_circle_outline;
        break;
      case BadgeStatus.pending:
        bg = AppColors.amberWarning.withOpacity(0.18);
        fg = const Color(0xFF9E6500);
        defaultIcon ??= Icons.schedule;
        break;
      case BadgeStatus.rejected:
      case BadgeStatus.suspended:
        bg = AppColors.redDestructive.withOpacity(0.15);
        fg = AppColors.redDestructive;
        defaultIcon ??= Icons.cancel;
        break;
      case BadgeStatus.completed:
        bg = AppColors.mintLeaf.withOpacity(0.25);
        fg = AppColors.pineTeal;
        defaultIcon ??= Icons.done_all;
        break;
      case BadgeStatus.onTheWay:
      case BadgeStatus.inProgress:
        bg = AppColors.frostedMint;
        fg = AppColors.seaGreen;
        defaultIcon ??= Icons.directions_run;
        break;
      case BadgeStatus.emergency:
        bg = AppColors.redDestructive.withOpacity(0.9);
        fg = AppColors.white;
        defaultIcon ??= Icons.crisis_alert;
        break;
      case BadgeStatus.coopOwner:
        bg = AppColors.celadon2.withOpacity(0.4);
        fg = AppColors.darkEmerald;
        defaultIcon ??= Icons.diversity_3;
        break;
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(defaultIcon, size: fontSize + 3, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
