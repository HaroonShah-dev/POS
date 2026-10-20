import 'package:flutter/material.dart';
import 'package:store_management_system/core/colors/app_colors.dart';

class SalesProductCard extends StatefulWidget {
  final String name;
  final String category;
  final double price;
  final int stock;
  final VoidCallback onTap;

  const SalesProductCard({
    super.key,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.onTap,
  });

  @override
  State<SalesProductCard> createState() => _SalesProductCardState();
}

class _SalesProductCardState extends State<SalesProductCard> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed != value) {
      setState(() => _isPressed = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lowStock = widget.stock <= 10;

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isPressed ? AppColors.primary : AppColors.border,
              width: _isPressed ? 1.4 : 1,
            ),
            boxShadow: _isPressed
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(16),
              splashColor: AppColors.primary.withValues(alpha: 0.12),
              highlightColor: AppColors.primary.withValues(alpha: 0.06),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Scale spacing/sizes based on the actual space the grid gave this card
                  final isCompact =
                      constraints.maxWidth < 160 || constraints.maxHeight < 130;

                  final padding = isCompact ? 12.0 : 16.0;
                  final iconBoxSize = isCompact ? 30.0 : 38.0;
                  final iconSize = isCompact ? 16.0 : 20.0;
                  final nameFontSize = isCompact ? 13.0 : 14.0;
                  final priceFontSize = isCompact ? 14.0 : 16.0;

                  return Padding(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: iconBoxSize,
                              width: iconBoxSize,
                              padding: EdgeInsets.all(isCompact ? 6 : 9),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: FittedBox(
                                child: Icon(
                                  Icons.inventory_2_rounded,
                                  color: AppColors.primary,
                                  size: iconSize,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isCompact ? 6 : 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      (lowStock ? Colors.orange : Colors.green)
                                          .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Stock: ${widget.stock}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: isCompact ? 10 : 12,
                                    color: lowStock
                                        ? Colors.orange.shade800
                                        : Colors.green.shade800,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        Text(
                          widget.name,
                          style: AppTextStyles.h4.copyWith(
                            fontSize: nameFontSize,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: isCompact ? 2 : 3),

                        Text(
                          widget.category,
                          style: TextStyle(
                            fontSize: isCompact ? 11 : 12,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: isCompact ? 6 : 8),

                        Text(
                          'Rs. ${widget.price.toStringAsFixed(0)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: priceFontSize,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
