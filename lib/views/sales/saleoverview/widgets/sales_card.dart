import 'package:flutter/material.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/models/sales_model.dart';
import 'package:store_management_system/core/utils/time_ago.dart'; // adjust path to wherever timeAgo() lives

class SaleCard extends StatefulWidget {
  final SaleModel sale;

  const SaleCard({super.key, required this.sale});

  @override
  State<SaleCard> createState() => _SaleCardState();
}

class _SaleCardState extends State<SaleCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final sale = widget.sale;

    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => setState(() => _expanded = !_expanded),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- Header row (always visible) ----------
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.receipt_long_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(sale.invoiceNumber, style: AppTextStyles.h4),
                        const SizedBox(height: 4),
                        Text(
                          timeAgo(sale.createdAt),
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.infoBg,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${sale.items.length} item${sale.items.length == 1 ? '' : 's'}',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Rs. ${sale.total.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // ---------- Expandable item list ----------
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                crossFadeState: _expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: const SizedBox.shrink(),
                secondChild: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1),
                    ),
                    ...sale.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.productName,
                                style: AppTextStyles.h4,
                              ),
                            ),
                            Text(
                              '${item.quantity} × Rs. ${item.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 70,
                              child: Text(
                                'Rs. ${item.subtotal.toStringAsFixed(0)}',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
