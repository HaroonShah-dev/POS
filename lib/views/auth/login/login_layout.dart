import 'package:flutter/material.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/core/constants/app_images.dart';

/// A single bullet in the left-hand brand panel's feature list.
class LoginFeature {
  final IconData icon;
  final String label;

  const LoginFeature(this.icon, this.label);
}

/// Responsive shell for the login screen.
///
/// Mobile / tablet: full-bleed background image with a scrim, brand mark
/// on top, then the form card.
/// Desktop: brand panel on the left (headline, subtitle, feature list),
/// form card on a plain surface on the right.
///
/// LoginScreen only supplies its copy and its form widget — all the
/// breakpoint/scaffolding logic lives here.
class LoginScreenLayout extends StatelessWidget {
  final Widget form;
  final String headline;
  final String subtitle;
  final List<LoginFeature> features;
  final String footerTagline;
  final double tabletFormMaxWidth;
  final double desktopFormMaxWidth;

  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 800;

  const LoginScreenLayout({
    super.key,
    required this.form,
    required this.headline,
    required this.subtitle,
    this.features = const [],
    this.footerTagline = 'GENERAL STORE MANAGEMENT SYSTEM',
    this.tabletFormMaxWidth = 480,
    this.desktopFormMaxWidth = 460,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            if (width < mobileBreakpoint) return _mobileLayout(context);
            if (width < tabletBreakpoint) return _tabletLayout(context);
            return _desktopLayout(context);
          },
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Brand mark — small bordered icon + wordmark. Plain, not a gradient
  // badge, so it reads as an identity lockup rather than a decoration.
  // ---------------------------------------------------------------------
  Widget _brandMark({bool light = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: light
                ? Colors.white.withValues(alpha: 0.12)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            border: Border.all(
              color: light
                  ? Colors.white.withValues(alpha: 0.25)
                  : AppColors.border,
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

  Widget _formCard({required Widget child, double? maxWidth}) {
    final card = Container(
      padding: const EdgeInsets.all(AppDimensions.spaceXl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
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
              colors: [
                Colors.black.withValues(alpha: 0.45),
                Colors.black.withValues(alpha: 0.25),
                Colors.black.withValues(alpha: 0.55),
              ],
            ),
          ),
        ),
        child,
      ],
    );
  }

  Widget _featureRow(LoginFeature feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(
            feature.icon,
            color: Colors.white.withValues(alpha: 0.75),
            size: 17,
          ),
          const SizedBox(width: AppDimensions.spaceSm),
          Text(
            feature.label,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              color: Colors.white.withValues(alpha: 0.82),
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(height: 1, color: Colors.white.withValues(alpha: 0.1));
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
              _formCard(child: form),
              const SizedBox(height: AppDimensions.spaceLg),
              Text(
                footerTagline,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  color: Colors.white.withValues(alpha: 0.7),
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
              _formCard(maxWidth: tabletFormMaxWidth, child: form),
            ],
          ),
        ),
      ),
    );
  }

  Widget _desktopLayout(BuildContext context) {
    return Row(
      children: [
        // LEFT — brand panel.
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
                  Container(
                    width: 36,
                    height: 3,
                    color: Colors.white.withValues(alpha: 0.55),
                  ),
                  const SizedBox(height: AppDimensions.spaceLg),
                  Text(
                    headline,
                    style: const TextStyle(
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
                    subtitle,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      color: Colors.white.withValues(alpha: 0.68),
                      fontSize: 15.5,
                      height: 1.6,
                    ),
                  ),
                  if (features.isNotEmpty) ...[
                    const SizedBox(height: AppDimensions.spaceXl),
                    for (int i = 0; i < features.length; i++) ...[
                      _featureRow(features[i]),
                      if (i != features.length - 1) _divider(),
                    ],
                  ],
                  const Spacer(),
                  Text(
                    footerTagline,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      color: Colors.white.withValues(alpha: 0.45),
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

        // RIGHT — plain surface, form card.
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
                child: _formCard(maxWidth: desktopFormMaxWidth, child: form),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
