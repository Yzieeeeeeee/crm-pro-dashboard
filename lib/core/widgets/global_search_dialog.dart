import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:crm_dashboard_app/core/constants/app_colors.dart';
import 'package:crm_dashboard_app/core/constants/app_radius.dart';
import 'package:crm_dashboard_app/features/companies/provider/companies_provider.dart';
import 'package:crm_dashboard_app/routes/app_router.dart';

/// Gorgeous Stripe/Linear-style Command Palette modal.
class GlobalSearchDialog extends ConsumerStatefulWidget {
  const GlobalSearchDialog({super.key});

  static void show(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'GlobalSearchBarrier',
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) => const GlobalSearchDialog(),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
    );
  }

  @override
  ConsumerState<GlobalSearchDialog> createState() => _GlobalSearchDialogState();
}

class _GlobalSearchDialogState extends ConsumerState<GlobalSearchDialog> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final companiesAsync = ref.watch(companiesProvider);
    final allCompanies = companiesAsync.valueOrNull ?? [];

    // Filter local list for instant results
    final filtered = allCompanies.where((c) {
      final q = _query.toLowerCase();
      return c.name.toLowerCase().contains(q) ||
          c.email.toLowerCase().contains(q) ||
          c.company.name.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 550.w, maxHeight: 400.h),
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: AppRadius.borderRadiusLg,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.gray200,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {}, // Prevent tap dismissal inside card
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Input Area
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          size: 20.w,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.gray400,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            autofocus: true,
                            onChanged: (val) => setState(() => _query = val),
                            decoration: InputDecoration(
                              hintText: 'Search companies, emails, catchphrases...',
                              hintStyle: TextStyle(
                                fontSize: 14.sp,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.gray400,
                              ),
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withValues(alpha: 0.1) : AppColors.gray100,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            '',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.gray500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // Results List
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.all(24.w),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.find_in_page_outlined,
                                    size: 32.w,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.gray400,
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    _query.isEmpty ? 'Type to search...' : 'No matches found',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.gray500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final c = filtered[index];
                              return ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                                leading: Container(
                                  width: 32.w,
                                  height: 32.w,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.avatarGradients[c.id % AppColors.avatarGradients.length],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      c.initials,
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  c.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                  ),
                                ),
                                subtitle: Text(
                                  '${c.company.name} • ${c.email}',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.gray500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 12.w,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.gray400,
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  context.push(AppRoutes.companyDetails.replaceAll(':id', '${c.id}'));
                                },
                              );
                            },
                          ),
                  ),
                  const Divider(height: 1),

                  // Footer hints
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tip: Use navigation to close',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.gray400,
                          ),
                        ),
                        Text(
                          '${filtered.length} results',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.gray500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
