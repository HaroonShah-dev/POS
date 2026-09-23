import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/views/auth/authViewModel/auth_view_model.dart';
import 'package:store_management_system/views/auth/login/login_screen.dart';
import 'package:store_management_system/views/auth/widgets/custom_textform_field.dart';

class RegistrationForm extends StatefulWidget {
  final double? formWidth;

  const RegistrationForm({super.key, this.formWidth});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  static const double _pairBreakpoint = 420;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      builder: (context, child) {
        final isLoading = context.watch<AuthViewModel>().isloading;
        final authVm = context.read<AuthViewModel>();

        final content = Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: const Icon(
                  Icons.storefront_rounded,
                  color: AppColors.primary,
                  size: 26,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              Text('Create Account', style: AppTextStyles.h1),
              const SizedBox(height: AppDimensions.spaceXs),
              Text(
                'Set up your store account to get started',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceXl),

              // ---- Account section ----
              _SectionLabel('Account Details'),
              const SizedBox(height: AppDimensions.spaceMd),
              CustomTextFormField(
                label: 'Email',
                hintText: 'Enter your email address',
                controller: authVm.emailController,
                validator: AppValidators.email,
                prefix: const Icon(Icons.email_outlined),
                isloading: isLoading,
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              CustomTextFormField(
                label: 'Full Name',
                hintText: 'Enter full name',
                controller: authVm.fullName,
                validator: (v) => AppValidators.required(v, field: 'Full name'),
                prefix: const Icon(Icons.person_outline_rounded),
                isloading: isLoading,
              ),
              const SizedBox(height: AppDimensions.spaceLg),

              // ---- Store section ----
              _SectionLabel('Store Information'),
              const SizedBox(height: AppDimensions.spaceMd),
              // Store Name + Phone are both short fields, so pair them
              // side by side on anything wider than a narrow phone.
              LayoutBuilder(
                builder: (context, constraints) {
                  final storeField = CustomTextFormField(
                    label: 'Store Name',
                    hintText: 'Enter your store name',
                    controller: authVm.storeName,
                    validator: (v) =>
                        AppValidators.required(v, field: 'Store name'),
                    prefix: const Icon(Icons.storefront_outlined),
                    isloading: isLoading,
                  );
                  final phoneField = CustomTextFormField(
                    label: 'Phone Number',
                    hintText: 'Enter contact number',
                    controller: authVm.phone,
                    validator: AppValidators.phone,
                    prefix: const Icon(Icons.phone_outlined),
                    isloading: isLoading,
                  );

                  if (constraints.maxWidth < _pairBreakpoint) {
                    return Column(
                      children: [
                        storeField,
                        const SizedBox(height: AppDimensions.spaceMd),
                        phoneField,
                      ],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: storeField),
                      const SizedBox(width: AppDimensions.spaceMd),
                      Expanded(child: phoneField),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppDimensions.spaceLg),

              _SectionLabel('Security'),
              const SizedBox(height: AppDimensions.spaceMd),
              CustomTextFormField(
                label: 'Password',
                hintText: 'Create a password',
                controller: authVm.passwordController,
                obscureText: true,
                validator: AppValidators.password,
                prefix: const Icon(Icons.lock_outline_rounded),
                isloading: isLoading,
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              CustomTextFormField(
                label: 'Confirm Password',
                hintText: 'Re-enter your password',
                controller: authVm.confirmPassword,
                obscureText: true,
                validator: (value) => AppValidators.confirmPassword(
                  value,
                  authVm.passwordController.text,
                ),
                prefix: const Icon(Icons.lock_outline_rounded),
                isloading: isLoading,
              ),
              const SizedBox(height: AppDimensions.spaceLg),

              Text(
                'By creating an account you agree to our Terms of Service '
                'and Privacy Policy.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: AppDimensions.spaceLg),

              SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeight,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            authVm.register(context);
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.textOnPrimary,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Create Account'),
                            SizedBox(width: AppDimensions.spaceSm),
                            Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceLg),

              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.divider)),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spaceSm,
                    ),
                    child: Text(
                      'or sign up with',
                      style: AppTextStyles.caption,
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.divider)),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceLg),

              Row(
                children: [
                  Expanded(
                    child: _SocialButton(
                      icon: Icons.g_mobiledata_rounded,
                      label: 'Google',
                      onTap: () {
                        // authVm.signInWithGoogle(context);
                      },
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceMd),
                  Expanded(
                    child: _SocialButton(
                      icon: Icons.facebook,
                      label: 'Facebook',
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceLg),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: AppTextStyles.bodyMedium,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: Text(
                      'Login',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

        if (widget.formWidth == null) return content;
        return SizedBox(width: widget.formWidth, child: content);
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.label.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
        side: const BorderSide(color: AppColors.border),
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
      icon: Icon(icon, size: 20, color: AppColors.textSecondary),
      label: Text(label, style: AppTextStyles.bodyMedium),
    );
  }
}
