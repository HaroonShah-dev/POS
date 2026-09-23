import 'package:flutter/material.dart';
import 'package:store_management_system/core/colors/app_colors.dart';

class ProductFilter extends StatefulWidget {
  final Function(String) onFilterSelected;

  const ProductFilter({super.key, required this.onFilterSelected});

  @override
  State<ProductFilter> createState() => _ProductFilterState();
}

class _ProductFilterState extends State<ProductFilter> {
  String selectedFilter = 'All';

  final List<String> filters = ['All', 'In Stock', 'Low Stock', 'Out of Stock'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedFilter,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),

          onChanged: (value) {
            if (value == null) return;

            setState(() {
              selectedFilter = value;
            });

            // Send selected filter to ProductScreen
            widget.onFilterSelected(value);
          },

          items: filters.map((filter) {
            return DropdownMenuItem<String>(
              value: filter,
              child: Row(
                children: [
                  const Icon(Icons.filter_list, size: 18),
                  const SizedBox(width: 8),
                  Text(filter),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
