import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:crm_dashboard_app/core/constants/app_colors.dart';
import 'package:crm_dashboard_app/core/constants/app_spacing.dart';
import 'package:crm_dashboard_app/core/theme/theme_provider.dart';
import 'package:crm_dashboard_app/core/utils/responsive_helper.dart';
import 'package:crm_dashboard_app/core/widgets/app_card.dart';
import 'package:crm_dashboard_app/core/widgets/app_text.dart';
import 'package:crm_dashboard_app/core/widgets/custom_app_bar.dart';
import 'package:crm_dashboard_app/features/auth/provider/auth_provider.dart';
import 'package:crm_dashboard_app/core/localization/app_localizations.dart';
import 'package:crm_dashboard_app/routes/app_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final user = ref.watch(authProvider).user;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = context.tr(ref);
    final currentLang = ref.watch(localizationProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: locale.translate('settings'),
        showSearch: false,
        showNotifications: false,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding.copyWith(
          bottom: AppSpacing.screenPadding.bottom + (ResponsiveHelper.isMobile(context) ? 120.h : 0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(locale.translate('account'), context),
            AppSpacing.gapSm,
            AppCard(
              padding: EdgeInsets.zero,
              child: ListTile(
                onTap: () => context.push('/profile'),
                contentPadding: AppSpacing.paddingBase,
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: AppText(
                    user?.initials ?? 'U',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                title: AppText.titleMedium(
                  user?.name ?? 'User Name',
                  fontWeight: FontWeight.w600,
                ),
                subtitle: AppText.bodySmall(
                  user?.email ?? 'user@email.com',
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
                trailing: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: AppText.labelSmall(
                    user?.role ?? 'Role',
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            AppSpacing.gapXxl,
            _buildSectionHeader(locale.translate('appearance'), context),
            AppSpacing.gapSm,
            _buildThemeSelector(context, ref, themeMode, locale),
            AppSpacing.gapXxl,
            _buildSectionHeader(locale.translate('language'), context),
            AppSpacing.gapSm,
            _buildLanguageSelector(context, ref, currentLang),
            AppSpacing.gapXxl,
            _buildSectionHeader(locale.translate('about'), context),
            AppSpacing.gapSm,
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline_rounded),
                    title: AppText.bodyMedium(locale.translate('about_crm')),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/settings/about'),
                  ),

                  ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: AppText.bodyMedium(locale.translate('terms')),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/settings/terms'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: AppText.bodyMedium(locale.translate('privacy')),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/settings/privacy'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.code_rounded),
                    title: AppText.bodyMedium(locale.translate('version')),
                    trailing: AppText.bodyMedium(
                      '1.0.0+1',
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapXxl,
            _buildSectionHeader(locale.translate('actions'), context),
            AppSpacing.gapSm,
            AppCard(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: const Icon(Icons.logout_rounded, color: AppColors.error),
                title: AppText.bodyMedium(
                  locale.translate('logout'),
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
                onTap: () {
                  ref.read(authProvider.notifier).logout();
                  context.go(AppRoutes.login);
                },
              ),
            ),
            AppSpacing.gapXxl,
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context, WidgetRef ref, ThemeMode currentMode, AppLocalizations locale) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                currentMode == ThemeMode.dark
                    ? Icons.dark_mode_rounded
                    : (currentMode == ThemeMode.light
                        ? Icons.light_mode_rounded
                        : Icons.brightness_auto_rounded),
                size: 20.w,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              SizedBox(width: 8.w),
              AppText.titleMedium(
                locale.translate('theme_mode'),
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildThemeOptionCard(
                  context: context,
                  ref: ref,
                  mode: ThemeMode.light,
                  currentMode: currentMode,
                  label: locale.translate('theme_light'),
                  icon: Icons.light_mode_rounded,
                  activeColor: AppColors.primary,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildThemeOptionCard(
                  context: context,
                  ref: ref,
                  mode: ThemeMode.dark,
                  currentMode: currentMode,
                  label: locale.translate('theme_dark'),
                  icon: Icons.dark_mode_rounded,
                  activeColor: AppColors.primaryLight,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildThemeOptionCard(
                  context: context,
                  ref: ref,
                  mode: ThemeMode.system,
                  currentMode: currentMode,
                  label: locale.translate('theme_system'),
                  icon: Icons.brightness_auto_rounded,
                  activeColor: isDark ? Colors.cyanAccent : Colors.indigoAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOptionCard({
    required BuildContext context,
    required WidgetRef ref,
    required ThemeMode mode,
    required ThemeMode currentMode,
    required String label,
    required IconData icon,
    required Color activeColor,
  }) {
    final isSelected = mode == currentMode;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color cardBg;
    if (isSelected) {
      cardBg = isDark
          ? AppColors.primaryLight.withValues(alpha: 0.1)
          : AppColors.primary.withValues(alpha: 0.05);
    } else {
      cardBg = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFAFAFA);
    }

    final borderColor = isSelected
        ? activeColor
        : (isDark ? Colors.white10 : Colors.black12);

    return InkWell(
      onTap: () {
        ref.read(themeProvider.notifier).setThemeMode(mode);
      },
      borderRadius: BorderRadius.circular(12.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? activeColor
                  : (isDark ? Colors.white38 : Colors.black38),
              size: 20.w,
            ),
            SizedBox(height: 6.h),
            AppText.bodySmall(
              label,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? (isDark ? Colors.white : Colors.black87)
                  : (isDark ? Colors.white54 : Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
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

  Widget _buildLanguageSelector(BuildContext context, WidgetRef ref, AppLanguage currentLang) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = context.tr(ref);

    return AppCard(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.language_rounded,
                size: 20.w,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              SizedBox(width: 8.w),
              AppText.titleMedium(
                locale.translate('language'),
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildLanguageOptionCard(
                  context: context,
                  ref: ref,
                  lang: AppLanguage.english,
                  currentLang: currentLang,
                  label: 'English',
                  flag: '🇺🇸',
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildLanguageOptionCard(
                  context: context,
                  ref: ref,
                  lang: AppLanguage.spanish,
                  currentLang: currentLang,
                  label: 'Español',
                  flag: '🇪🇸',
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildLanguageOptionCard(
                  context: context,
                  ref: ref,
                  lang: AppLanguage.french,
                  currentLang: currentLang,
                  label: 'Français',
                  flag: '🇫🇷',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOptionCard({
    required BuildContext context,
    required WidgetRef ref,
    required AppLanguage lang,
    required AppLanguage currentLang,
    required String label,
    required String flag,
  }) {
    final isSelected = lang == currentLang;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color cardBg;
    if (isSelected) {
      cardBg = isDark
          ? AppColors.primaryLight.withValues(alpha: 0.1)
          : AppColors.primary.withValues(alpha: 0.05);
    } else {
      cardBg = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFAFAFA);
    }

    final borderColor = isSelected
        ? AppColors.primary
        : (isDark ? Colors.white10 : Colors.black12);

    return InkWell(
      onTap: () {
        ref.read(localizationProvider.notifier).setLanguage(lang);
      },
      borderRadius: BorderRadius.circular(12.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              flag,
              style: TextStyle(fontSize: 20.sp),
            ),
            SizedBox(height: 6.h),
            AppText.bodySmall(
              label,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? (isDark ? Colors.white : Colors.black87)
                  : (isDark ? Colors.white54 : Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
