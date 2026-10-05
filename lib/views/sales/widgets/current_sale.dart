import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/models/product_model.dart';
import 'package:store_management_system/services/printer_services.dart';
import 'package:store_management_system/views/auth/authViewModel/auth_view_model.dart';
import 'package:store_management_system/views/sales/sales_view_model.dart';

class CurrentSale extends StatelessWidget {
  const CurrentSale({super.key});

  @override
  Widget build(BuildContext context) {
    final sales = context.watch<SalesViewModel>();

    return Consumer<AuthViewModel>(
      builder: (context, viewmodel, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            // Responds to BOTH width (narrow side panel) and height
            // (short stacked box on small windows) independently.
            final isNarrow = constraints.maxWidth < 360;
            final isShort = constraints.maxHeight < 380;
            final isCompact = isNarrow || isShort;

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // ---------- Header ----------
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      isNarrow ? 14 : 20,
                      isShort ? 12 : (isNarrow ? 14 : 20),
                      isNarrow ? 8 : 12,
                      isShort ? 8 : (isNarrow ? 12 : 16),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: isCompact ? 15 : 20,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: Icon(
                            Icons.storefront_rounded,
                            color: AppColors.primary,
                            size: isCompact ? 15 : 20,
                          ),
                        ),
                        SizedBox(width: isNarrow ? 8 : 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                viewmodel.userStoreName ?? 'My Store',
                                style: AppTextStyles.h4.copyWith(
                                  fontSize: isCompact ? 13 : null,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // Hide phone number entirely when very short on space
                              if (viewmodel.userPhone != null && !isShort)
                                Text(
                                  viewmodel.userPhone!,
                                  style: AppTextStyles.label.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: sales.currentSale.isEmpty
                              ? null
                              : () =>
                                    context.read<SalesViewModel>().clearSale(),
                          icon: const Icon(Icons.delete_outline_rounded),
                          tooltip: 'Clear Sale',
                          iconSize: isCompact ? 20 : 24,
                          padding: isCompact
                              ? const EdgeInsets.all(6)
                              : const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                          style: IconButton.styleFrom(
                            foregroundColor: Colors.red.shade400,
                            disabledForegroundColor: Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (sales.lastInvoiceNumber != null &&
                      sales.currentSale.isEmpty &&
                      !isShort) // skip this badge entirely when short on height
                    Padding(
                      padding: EdgeInsets.only(
                        left: isNarrow ? 14 : 20,
                        right: isNarrow ? 14 : 20,
                        bottom: 12,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                size: 14,
                                color: Colors.green.shade700,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'Invoice: ${sales.lastInvoiceNumber!}',
                                  style: AppTextStyles.label.copyWith(
                                    color: Colors.green.shade800,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  const Divider(height: 1),

                  // ---------- Cart items ----------
                  Expanded(
                    child: sales.currentSale.isEmpty
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.all(isCompact ? 14 : 24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.shopping_cart_outlined,
                                    size: isCompact ? 28 : 40,
                                    color: Colors.grey.shade300,
                                  ),
                                  SizedBox(height: isCompact ? 6 : 10),
                                  Text(
                                    'No items added yet',
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: isCompact ? 12 : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.fromLTRB(
                              isNarrow ? 10 : 16,
                              isShort ? 8 : 12,
                              isNarrow ? 10 : 16,
                              isShort ? 8 : 12,
                            ),
                            itemCount: sales.currentSale.length,
                            separatorBuilder: (_, _) =>
                                SizedBox(height: isShort ? 2 : 4),
                            itemBuilder: (context, index) {
                              final product = sales.currentSale[index];
                              final qty = sales.quantities[product.id] ?? 1;
                              return _SaleItem(
                                name: product.productName,
                                quantity: qty,
                                price: product.price,
                                isCompact: isCompact,
                                onRemove: () => context
                                    .read<SalesViewModel>()
                                    .removeFromSale(product.id),
                              );
                            },
                          ),
                  ),

                  const Divider(height: 1),

                  // ---------- Summary + Action ----------
                  Padding(
                    padding: EdgeInsets.all(
                      isShort ? 12 : (isNarrow ? 14 : 20),
                    ),
                    child: Column(
                      children: [
                        _SummaryRow(
                          title: 'Subtotal',
                          value: 'Rs. ${sales.grandTotal.toStringAsFixed(0)}',
                        ),
                        SizedBox(height: isShort ? 4 : 8),
                        // Skip discount row entirely when really tight on height
                        if (!isShort) ...[
                          const _SummaryRow(title: 'Discount', value: 'Rs. 0'),
                          const SizedBox(height: 14),
                        ],
                        const Divider(height: 1),
                        SizedBox(height: isShort ? 8 : 14),
                        _SummaryRow(
                          title: 'Total',
                          value: 'Rs. ${sales.grandTotal.toStringAsFixed(0)}',
                          isTotal: true,
                        ),
                        SizedBox(height: isShort ? 12 : 20),

                        SizedBox(
                          width: double.infinity,
                          height: isCompact ? 42 : 50,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey.shade300,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            icon: sales.isProcessingSale
                                ? const SizedBox.shrink()
                                : Icon(
                                    Icons.check_circle_outline_rounded,
                                    size: isCompact ? 16 : 20,
                                  ),
                            label: sales.isProcessingSale
                                ? SizedBox(
                                    width: isCompact ? 16 : 20,
                                    height: isCompact ? 16 : 20,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    isCompact ? 'COMPLETE' : 'COMPLETE SALE',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                      fontSize: isCompact ? 13 : null,
                                    ),
                                  ),
                            onPressed:
                                sales.currentSale.isEmpty ||
                                    sales.isProcessingSale
                                ? null
                                : () async {
                                    final items = List<ProductModel>.from(
                                      sales.currentSale,
                                    );
                                    final quantities = Map<String, int>.from(
                                      sales.quantities,
                                    );
                                    final total = sales.grandTotal;
                                    final storeName =
                                        viewmodel.userStoreName ?? 'My Store';
                                    final storePhone =
                                        viewmodel.userPhone ?? '';

                                    final success = await context
                                        .read<SalesViewModel>()
                                        .completeSale(context);
                                    final invoiceNumber = context
                                        .read<SalesViewModel>()
                                        .lastInvoiceNumber;

                                    if (success) {
                                      try {
                                        final printer = PrinterService();
                                        final devices = await printer
                                            .getUsbPrinters();
                                        final target = printer.pickThermal(
                                          devices,
                                        );
                                        if (target != null) {
                                          await printer.printSale(
                                            target: target,
                                            storeName: storeName,
                                            storePhone: storePhone,
                                            items: items,
                                            quantities: quantities,
                                            total: total,
                                          );
                                        } else if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Thermal printer nahi mila',
                                                  ),
                                                ),
                                              );
                                        }
                                      } catch (e) {
                                        debugPrint('Print error: $e');
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text('Print error: $e'),
                                              backgroundColor:
                                                  Colors.orange.shade800,
                                              duration: const Duration(
                                                seconds: 10,
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    }

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          content: Text(
                                            success && invoiceNumber != null
                                                ? 'Sale completed • $invoiceNumber'
                                                : 'Sale failed',
                                          ),
                                          backgroundColor: success
                                              ? Colors.green.shade600
                                              : Colors.red.shade600,
                                        ),
                                      );
                                    }
                                  },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _SaleItem extends StatelessWidget {
  final String name;
  final int quantity;
  final double price;
  final bool isCompact;
  final VoidCallback onRemove;

  const _SaleItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.onRemove,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 10 : 12,
        vertical: isCompact ? 7 : 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.label.copyWith(
                    fontSize: isCompact ? 12 : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isCompact ? 1 : 2),
                Text(
                  '$quantity × Rs. ${price.toStringAsFixed(0)}',
                  style: AppTextStyles.label.copyWith(
                    color: Colors.grey.shade600,
                    fontSize: isCompact ? 10 : null,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Rs. ${(quantity * price).toStringAsFixed(0)}',
            style: AppTextStyles.label.copyWith(
              fontSize: isCompact ? 12 : null,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: 6),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onRemove,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.close_rounded,
                size: isCompact ? 14 : 16,
                color: Colors.grey.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isTotal;

  const _SummaryRow({
    required this.title,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: isTotal
              ? AppTextStyles.label
              : AppTextStyles.label.copyWith(color: Colors.grey.shade600),
        ),
        Text(
          value,
          style: isTotal
              ? AppTextStyles.label.copyWith(
                  fontSize: 18,
                  color: AppColors.primary,
                )
              : AppTextStyles.label,
        ),
      ],
    );
  }
}
