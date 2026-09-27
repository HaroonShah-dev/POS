import 'package:flutter/material.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/core/constants/app_images.dart';
import 'package:store_management_system/views/auth/register/register_screen.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  static const double _mobileBreakpoint = 600;
  static const double _tabletBreakpoint = 800;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            if (width < _mobileBreakpoint) return _mobileLayout(context);
            if (width < _tabletBreakpoint) return _tabletLayout(context);
            return _desktopLayout(context);
          },
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Shared brand mark — small logo badge + wordmark, reused on every
  // breakpoint so the identity reads consistently everywhere.
  // ---------------------------------------------------------------------
  Widget _brandMark({bool light = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: light ? Colors.white : AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            border: Border.all(
              color: light ? Colors.white : AppColors.border,
              width: 1,
            ),
          ),
          child: Icon(
            Icons.storefront_rounded,
            color: light ? Colors.white : AppColors.primary,
            size: 19,
          ),
        ),
        const SizedBox(width: AppDimensions.spaceSm),
        Text(
          'StoreFlow',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            color: light ? Colors.white : AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // Shared card so mobile/tablet/desktop stay visually consistent instead
  // of each picking a different border/shadow color.
  // ---------------------------------------------------------------------
  Widget _formCard({required Widget child, double? maxWidth}) {
    final card = Container(
      padding: const EdgeInsets.all(AppDimensions.spaceXl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );

    if (maxWidth == null) return card;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: card,
    );
  }

  // Full-bleed background image with a scrim so the card stays readable
  // and the brand mark can sit on top of it, on mobile & tablet.
  Widget _imageBackdrop({required Widget child}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image(image: AssetImage(AppImages.image), fit: BoxFit.cover),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.black, Colors.black],
            ),
          ),
        ),
        child,
      ],
    );
  }

  Widget _mobileLayout(BuildContext context) {
    return _imageBackdrop(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _brandMark(light: true),
              const SizedBox(height: AppDimensions.spaceLg),
              _formCard(child: const RegistrationForm()),
              const SizedBox(height: AppDimensions.spaceLg),
              Text(
                'GENERAL STORE MANAGEMENT SYSTEM',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabletLayout(BuildContext context) {
    return _imageBackdrop(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _brandMark(light: true),
              const SizedBox(height: AppDimensions.spaceLg),
              _formCard(maxWidth: 480, child: const RegistrationForm()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _desktopLayout(BuildContext context) {
    return Row(
      children: [
        // LEFT — brand panel, matching the login screen's identity so the
        // two auth screens read as one cohesive flow.
        Expanded(
          flex: 5,
          child: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: Padding(
              padding: const EdgeInsets.all(56),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _brandMark(light: true),
                  const Spacer(),
                  Container(width: 36, height: 3, color: Colors.white),
                  const SizedBox(height: AppDimensions.spaceLg),
                  const Text(
                    'Start managing smarter.',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      color: Colors.white,
                      fontSize: 34,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceMd),
                  Text(
                    'Create your account and get your store, inventory '
                    'and sales set up in minutes.',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      color: Colors.white,
                      fontSize: 15.5,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceXl),
                  _featureRow(
                    Icons.inventory_2_outlined,
                    'Real-time inventory tracking',
                  ),
                  _divider(),
                  _featureRow(
                    Icons.point_of_sale_outlined,
                    'Fast, simple point of sale',
                  ),
                  _divider(),
                  _featureRow(
                    Icons.insights_outlined,
                    'Sales insights at a glance',
                  ),
                  const Spacer(),
                  Text(
                    'GENERAL STORE MANAGEMENT SYSTEM',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // RIGHT — plain surface, form card. No duplicated background image
        // and no formWidth fighting the ConstrainedBox around it.
        Expanded(
          flex: 4,
          child: Container(
            color: AppColors.background,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 40,
                ),
                child: _formCard(
                  maxWidth: 460,
                  child: const RegistrationForm(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _featureRow(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 17),
          const SizedBox(width: AppDimensions.spaceSm),
          Text(
            label,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              color: Colors.white,
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(height: 1, color: Colors.white);
  }
}
