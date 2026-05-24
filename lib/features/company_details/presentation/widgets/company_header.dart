import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:crm_dashboard_app/core/constants/app_colors.dart';
import 'package:crm_dashboard_app/core/constants/app_spacing.dart';
import 'package:crm_dashboard_app/core/widgets/status_badge.dart';
import 'package:crm_dashboard_app/features/companies/data/company_model.dart';

class CompanyHeader extends StatelessWidget {
  final CompanyModel company;

  const CompanyHeader({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final status = company.id % 2 == 0 ? StatusType.active : StatusType.pending;
    final gradient = AppColors
        .avatarGradients[company.id % AppColors.avatarGradients.length];

    return Center(
      child: Column(
        children: [
          Hero(
            tag: 'company-avatar-${company.id}',
            child: Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                gradient: gradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: gradient.colors.last.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  company.initials,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          AppSpacing.gapLg,
          Text(
            company.companyName,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapXs,
          Text(
            'Contact: ${company.contactName} • ${company.company.catchPhrase}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapSm,
          StatusBadge(
            label: status == StatusType.active
                ? 'Active Client'
                : 'Pending Review',
            type: status,
          ),
        ],
      ),
    );
  }
}
