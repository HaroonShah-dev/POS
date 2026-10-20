import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/models/product_model.dart';
import 'package:store_management_system/views/products/product_view_model.dart';

void showAddProductDialog(BuildContext context, {ProductModel? product}) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final bool isEdit = product != null;

  // Get ViewModel
  final viewModel = context.read<ProductViewModel>();

  // If editing, fill the existing product data
  if (isEdit) {
    viewModel.productName.text = product.productName;
    viewModel.category.text = product.category;
    viewModel.price.text = product.price.toString();
    viewModel.stock.text = product.stock.toString();
  } else {
    // New product, make sure fields are empty
    viewModel.productName.clear();
    viewModel.category.clear();
    viewModel.price.clear();
    viewModel.stock.clear();
  }

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext dialogContext) {
      return Consumer<ProductViewModel>(
        builder: (context, viewModel, child) {
          return Center(
            child: SizedBox(
              width: 450,
              child: AlertDialog(
                backgroundColor: AppColors.infoBg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),

                // ---------------- TITLE ----------------
                title: Row(
                  children: [
                    Icon(
                      isEdit
                          ? Icons.edit_outlined
                          : Icons.add_shopping_cart_rounded,
                      color: Colors.blue,
                      size: 24,
                    ),

                    const SizedBox(width: 10),

                    Text(
                      isEdit ? 'Edit Product' : 'Add New Product',
                      style: AppTextStyles.h3,
                    ),
                  ],
                ),

                // ---------------- FORM ----------------
                content: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 8),
                        // _buildDialogTextField(
                        //   viewModel.productId,
                        //   'Product ID',
                        //   Icons.tag_outlined,
                        //   validator: AppValidators.username,
                        // ),
                        const SizedBox(height: 8),
                        _buildDialogTextField(
                          viewModel.productName,
                          'Product Name',
                          Icons.shopping_bag_outlined,
                          validator: AppValidators.username,
                        ),

                        const SizedBox(height: 16),

                        _buildDialogTextField(
                          viewModel.category,
                          'Category',
                          Icons.category_outlined,
                          validator: AppValidators.username,
                        ),

                        const SizedBox(height: 16),

                        _buildDialogTextField(
                          viewModel.price,
                          'Price (Rs.)',
                          Icons.payments_outlined,
                          validator: AppValidators.number,
                          isNumeric: true,
                        ),

                        const SizedBox(height: 16),

                        _buildDialogTextField(
                          viewModel.stock,
                          'Initial Stock',
                          Icons.inventory_2_outlined,
                          validator: AppValidators.number,
                          isNumeric: true,
                        ),
                      ],
                    ),
                  ),
                ),

                // ---------------- BUTTONS ----------------
                actionsPadding: const EdgeInsets.only(right: 10, bottom: 20),

                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: viewModel.isloading
                          ? null
                          : () async {
                              if (!formKey.currentState!.validate()) {
                                return;
                              }

                              if (isEdit) {
                                // -------- UPDATE --------
                                await viewModel.updateProduct(
                                  productId: product.id,
                                  productName: viewModel.productName.text
                                      .trim(),
                                  category: viewModel.category.text.trim(),
                                  price: double.parse(
                                    viewModel.price.text.trim(),
                                  ),
                                  stock: int.parse(viewModel.stock.text.trim()),
                                );
                              } else {
                                // -------- ADD --------
                                await viewModel.addProduct(dialogContext);
                              }

                              if (dialogContext.mounted) {
                                Navigator.pop(dialogContext);
                              }
                            },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),

                      child: viewModel.isloading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(isEdit ? 'Update Product' : 'Save Product'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

// ---------------------------------------------------------
// TEXT FIELD
// ---------------------------------------------------------

Widget _buildDialogTextField(
  TextEditingController controller,
  String label,
  IconData icon, {
  bool isNumeric = false,
  required FormFieldValidator<String> validator,
}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
}
