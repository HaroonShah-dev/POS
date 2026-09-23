import 'package:flutter/material.dart';
import 'package:store_management_system/core/colors/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget? prefix;
  final bool isloading;

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.validator,
    this.prefix,
    this.isloading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodyLarge),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          enabled: !isloading,
          // Explicit style so typed text NEVER silently falls back to
          // Flutter's default disabled/dimmed text color — which is what
          // was making it look the same as the field's fill color.
          style: AppTextStyles.bodyMedium.copyWith(
            color: isloading ? AppColors.textHint : AppColors.textPrimary,
          ),
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            filled: true,
            fillColor: isloading
                ? AppColors.surfaceMuted
                : AppColors.surface, // was AppColors.background
            hintText: hintText,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textHint,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            prefixIcon: prefix,
            prefixIconColor: AppColors.primary,
          ),
          validator: validator,
        ),
      ],
    );
  }
}
