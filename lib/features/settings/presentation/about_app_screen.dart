import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:crm_dashboard_app/core/constants/app_colors.dart';
import 'package:crm_dashboard_app/core/constants/app_spacing.dart';
import 'package:crm_dashboard_app/core/localization/app_localizations.dart';
import 'package:crm_dashboard_app/core/utils/responsive_helper.dart';
import 'package:crm_dashboard_app/core/widgets/app_card.dart';
import 'package:crm_dashboard_app/core/widgets/app_text.dart';
import 'package:crm_dashboard_app/core/widgets/custom_app_bar.dart';

/// A premium, highly-designed overview page detailing application capabilities,
class AboutAppScreen extends ConsumerWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.tr(ref);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = ResponsiveHelper.isMobile(context);

    // Limit screen width on wide desktop monitors
    final contentWidth = isMobile ? double.infinity : 680.w;

    return Scaffold(
      appBar: CustomAppBar(
        title: locale.translate('about_dashboard_title'),
        showBack: true,
        showSearch: false,
        showNotifications: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Container(
            width: contentWidth,
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Hero Section ─────────────────────────────────────
                _buildHeroBanner(context, isDark, locale),
                AppSpacing.gapXxl,

                // ── Core Capabilities Section ──────────────────────────
                _buildSectionTitle(locale.translate('core_capabilities'), context),
                AppSpacing.gapSm,
                _buildCapabilitiesCard(isDark, locale),
                AppSpacing.gapXxl,

                // ── Tech Stack Section ──────────────────────────────────
                _buildSectionTitle(locale.translate('tech_stack'), context),
                AppSpacing.gapSm,
                _buildTechStackGrid(context, isDark),
                AppSpacing.gapXxl,

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context, bool isDark, AppLocalizations locale) {
    return Column(
      children: [
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.hub_rounded,
            color: Colors.white,
            size: 40.w,
          ),
        ),
        SizedBox(height: 16.h),
        AppText.headlineMedium(
          locale.translate('crm_dashboard'),
          fontWeight: FontWeight.w800,
        ),
        SizedBox(height: 4.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(100.r),
          ),
          child: AppText.labelSmall(
            'Version 1.0.0+1',
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        SizedBox(height: 16.h),
        AppText.bodyMedium(
          locale.translate('about_dashboard_desc'),
          textAlign: TextAlign.center,
          color: isDark ? Colors.white60 : Colors.black54,
        ),
      ],
    );
  }

  Widget _buildCapabilitiesCard(bool isDark, AppLocalizations locale) {
    return AppCard(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
      child: Column(
        children: [
          _buildCapabilityTile(
            icon: Icons.analytics_outlined,
            title: locale.translate('cap_analytics'),
            description: locale.translate('cap_analytics_desc'),
            isDark: isDark,
          ),
          const Divider(indent: 56, endIndent: 16, height: 1),
          _buildCapabilityTile(
            icon: Icons.business_center_outlined,
            title: locale.translate('cap_companies'),
            description: locale.translate('cap_companies_desc'),
            isDark: isDark,
          ),
          const Divider(indent: 56, endIndent: 16, height: 1),
          _buildCapabilityTile(
            icon: Icons.bolt_rounded,
            title: locale.translate('cap_loading'),
            description: locale.translate('cap_loading_desc'),
            isDark: isDark,
          ),
          const Divider(indent: 56, endIndent: 16, height: 1),
          _buildCapabilityTile(
            icon: Icons.palette_outlined,
            title: locale.translate('cap_layouts'),
            description: locale.translate('cap_layouts_desc'),
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildCapabilityTile({
    required IconData icon,
    required String title,
    required String description,
    required bool isDark,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20.w,
              color: isDark ? AppColors.primaryLight : AppColors.primary,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.titleSmall(
                  title,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 2.h),
                AppText.bodySmall(
                  description,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechStackGrid(BuildContext context, bool isDark) {
    final isMobile = ResponsiveHelper.isMobile(context);

    // Grid layout parameters based on size
    final items = [
      _TechItem('Flutter / Dart', 'Framework', Icons.widgets_outlined, isDark ? Colors.lightBlueAccent : Colors.blue),
      _TechItem('Riverpod', 'State Management', Icons.water_drop_outlined, isDark ? Colors.cyanAccent : Colors.teal),
      _TechItem('Hive DB', 'NoSQL Persistent Cache', Icons.storage_rounded, isDark ? Colors.amberAccent : Colors.orange),
      _TechItem('GoRouter', 'Declarative Routing', Icons.alt_route_rounded, isDark ? Colors.purpleAccent : Colors.purple),
      _TechItem('Google Poppins', 'Geometric Typography', Icons.font_download_outlined, isDark ? Colors.pinkAccent : Colors.pink),
      _TechItem('ScreenUtil', 'Responsive View Scaling', Icons.aspect_ratio_rounded, isDark ? Colors.lightGreenAccent : Colors.green),
    ];

    if (isMobile) {
      return Column(
        children: items.map((item) => Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: _buildTechStackItem(item, isDark),
        )).toList(),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        mainAxisExtent: 72.h,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildTechStackItem(items[index], isDark),
    );
  }

  Widget _buildTechStackItem(_TechItem item, bool isDark) {
    return AppCard(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Icon(
            item.icon,
            size: 24.w,
            color: item.color,
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText.bodyMedium(
                  item.name,
                  fontWeight: FontWeight.w600,
                ),
                AppText.bodySmall(
                  item.category,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: AppText.labelSmall(
        title,
        style: TextStyle(
          letterSpacing: 1.2,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

class _TechItem {
  final String name;
  final String category;
  final IconData icon;
  final Color color;

  const _TechItem(this.name, this.category, this.icon, this.color);
}
