import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:crm_dashboard_app/core/constants/app_colors.dart';
import 'package:crm_dashboard_app/core/constants/app_spacing.dart';
import 'package:crm_dashboard_app/core/widgets/error_state_widget.dart';
import 'package:crm_dashboard_app/core/widgets/shimmer_loading.dart';
import 'package:crm_dashboard_app/features/companies/provider/companies_provider.dart';
import 'package:crm_dashboard_app/features/company_details/presentation/widgets/company_header.dart';
import 'package:crm_dashboard_app/features/company_details/presentation/widgets/detail_info_card.dart';
import 'package:crm_dashboard_app/core/widgets/app_card.dart';

class CompanyDetailsScreen extends ConsumerWidget {
  final int companyId;

  const CompanyDetailsScreen({super.key, required this.companyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companyDetailsAsync = ref.watch(companyDetailsProvider(companyId));

    return Scaffold(
      body: companyDetailsAsync.when(
        data: (company) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200.h,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    company.companyName,
                    style: TextStyle(
                      color: Colors.white,
                      shadows: [
                        Shadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 4)
                      ],
                    ),
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: AppSpacing.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CompanyHeader(company: company),
                      AppSpacing.gapXxl,

                      // In a real app we'd use ResponsiveHelper for tablet grid layout here.
                      DetailInfoCard(
                        title: 'Contact Information',
                        items: [
                          InfoRow(
                              icon: Icons.email_rounded,
                              label: 'Email',
                              value: company.email),
                          InfoRow(
                              icon: Icons.phone_rounded,
                              label: 'Phone',
                              value: company.phone),
                          InfoRow(
                              icon: Icons.language_rounded,
                              label: 'Website',
                              value: company.website),
                        ],
                      ),
                      AppSpacing.gapLg,

                      DetailInfoCard(
                        title: 'Address',
                        items: [
                          InfoRow(
                              icon: Icons.location_on_rounded,
                              label: 'Street',
                              value:
                                  '${company.address.suite}, ${company.address.street}'),
                          InfoRow(
                              icon: Icons.location_city_rounded,
                              label: 'City',
                              value: company.address.city),
                          InfoRow(
                              icon: Icons.markunread_mailbox_rounded,
                              label: 'Zipcode',
                              value: company.address.zipcode),
                        ],
                      ),
                      AppSpacing.gapLg,

                      DetailInfoCard(
                        title: 'Business Details',
                        items: [
                          InfoRow(
                              icon: Icons.business_rounded,
                              label: 'Company',
                              value: company.company.name),
                          InfoRow(
                              icon: Icons.format_quote_rounded,
                              label: 'Catch Phrase',
                              value: company.company.catchPhrase),
                          InfoRow(
                              icon: Icons.work_rounded,
                              label: 'BS',
                              value: company.company.bs),
                        ],
                      ),
                      AppSpacing.gapLg,

                      Text(
                        'Notes',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      AppSpacing.gapSm,
                      AppCard(
                        child: Text(
                          'Met with the team last week. They are very interested in our enterprise plan. Follow up required next Monday.',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.8),
                                  ),
                        ),
                      ),
                      AppSpacing.gapXxl,
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Scaffold(
          appBar: CustomAppBar(title: 'Loading...'),
          body: CompanyDetailsShimmer(),
        ),
        error: (err, stack) => Scaffold(
          appBar: const CustomAppBar(title: 'Error'),
          body: ErrorStateWidget(
            message: err.toString(),
            onRetry: () => ref.invalidate(companyDetailsProvider(companyId)),
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text(title));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
