import 'package:flutter/material.dart';
import 'package:store_management_system/core/colors/app_colors.dart'; // Adjust path if needed

class ProductSearchBar extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const ProductSearchBar({super.key, this.onChanged, this.controller});

  @override
  State<ProductSearchBar> createState() => _ProductSearchBarState();
}

class _ProductSearchBarState extends State<ProductSearchBar> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 52,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _isFocused ? AppColors.primaryLight : AppColors.border,
          width: _isFocused ? 1.8 : 1.0,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AppColors.primaryDark,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        style: const TextStyle(fontSize: 15, color: AppColors.primaryLight),
        decoration: InputDecoration(
          hintText: 'Search products by name, id, or category...',
          hintStyle: _isFocused
              ? TextStyle(color: AppColors.textHint, fontSize: 14)
              : TextStyle(color: AppColors.textHint),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: _isFocused ? AppColors.primary : AppColors.textSecondary,
            size: 22,
          ),
          suffixIcon:
              widget.controller != null && widget.controller!.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18),
                  onPressed: () {
                    widget.controller!.clear();
                    if (widget.onChanged != null) widget.onChanged!('');
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 12,
          ),
        ),
      ),
    );
  }
}
