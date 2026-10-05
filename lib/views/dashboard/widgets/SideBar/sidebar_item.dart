import 'package:flutter/material.dart';
import 'package:store_management_system/core/colors/app_colors.dart';

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const SidebarItem({
    super.key,
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryDark : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 21,
                color: isSelected ? AppColors.background : Colors.grey,
              ),

              const SizedBox(width: 12),

              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColors.background : AppColors.textHint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
