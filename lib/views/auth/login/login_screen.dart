import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/views/auth/authViewModel/auth_view_model.dart';
import 'package:store_management_system/views/auth/login/login_layout.dart';
import 'package:store_management_system/views/auth/register/register_layout.dart';
import 'package:store_management_system/views/auth/widgets/custom_textform_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginScreenLayout(
      headline: 'Good to see you again.',
      subtitle:
          'Sign in to pick up right where you left off — your store, '
          'your data, exactly as you left it.',
      features: [
        LoginFeature(Icons.lock_outline_rounded, 'Bank-level data encryption'),
        LoginFeature(Icons.cloud_done_outlined, 'Automatic cloud backups'),
        LoginFeature(
          Icons.admin_panel_settings_outlined,
          'Role-based staff access',
        ),
      ],
      form: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  final double? formWidth;

  const LoginForm({super.key, this.formWidth});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;
  final bool _obscurePassword = true;

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
              // ---- Header ----
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.background,
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
              Text('Welcome Back', style: AppTextStyles.h1),
              const SizedBox(height: AppDimensions.spaceXs),
              Text(
                'Sign in to your store account',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceXl),

              // ---- Credentials ----
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
                label: 'Password',
                hintText: 'Enter your password',
                controller: authVm.passwordController,
                obscureText: _obscurePassword,
                validator: (v) => AppValidators.required(v, field: 'Password'),
                prefix: const Icon(Icons.lock_outline_rounded),
                // suffix: IconButton(
                //   onPressed: () =>
                //       setState(() => _obscurePassword = !_obscurePassword),
                //   icon: Icon(
                //     _obscurePassword
                //         ? Icons.visibility_outlined
                //         : Icons.visibility_off_outlined,
                //     size: 20,
                //     color: AppColors.textSecondary,
                //   ),
                // ),
                isloading: isLoading,
              ),
              const SizedBox(height: AppDimensions.spaceMd),

              // ---- Remember me / forgot password ----
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                          value: _rememberMe,
                          activeColor: AppColors.primary,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onChanged: (v) =>
                              setState(() => _rememberMe = v ?? false),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spaceXs),
                      Text('Remember me', style: AppTextStyles.bodySmall),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: wire up to your forgot-password flow.
                    },
                    child: Text(
                      'Forgot password?',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceLg),

              // ---- Submit ----
              SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeight,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            // TODO: replace with your view model's sign-in
                            // method, e.g. authVm.login(context).
                            authVm.login(context);
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
                            Text('Sign In'),
                            SizedBox(width: AppDimensions.spaceSm),
                            Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceLg),

              // ---- Divider ----
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.divider)),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spaceSm,
                    ),
                    child: Text(
                      'or sign in with',
                      style: AppTextStyles.caption,
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.divider)),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceLg),

              // ---- Social sign-in ----
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

              // ---- Footer ----
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: AppTextStyles.bodyMedium,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegistrationScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Register',
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
