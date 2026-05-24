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

enum LegalDocType { terms, privacy }

/// Reusable legal document screen that renders Terms of Service or Privacy Policy inside a premium card layout.
class DocumentViewerScreen extends ConsumerWidget {
  final LegalDocType docType;

  const DocumentViewerScreen({super.key, required this.docType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.tr(ref);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = ResponsiveHelper.isMobile(context);
    final title = docType == LegalDocType.terms ? locale.translate('terms') : locale.translate('privacy');
    final contentWidth = isMobile ? double.infinity : 720.w;

    final sections = docType == LegalDocType.terms ? _getTermsSections() : _getPrivacySections();

    return Scaffold(
      appBar: CustomAppBar(
        title: title,
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
                // ── Hero Icon Badge ─────────────────────────────────
                _buildHeaderIcon(isDark, locale),
                AppSpacing.gapXl,

                // ── Last Updated Banner ──────────────────────────────
                _buildLastUpdatedBanner(isDark, locale),
                AppSpacing.gapXl,

                // ── Document Sections ────────────────────────────────
                ...sections.map((section) => Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: _buildDocumentSectionCard(section, isDark),
                )),
                AppSpacing.gapXxxl,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(bool isDark, AppLocalizations locale) {
    return Column(
      children: [
        Container(
          width: 64.w,
          height: 64.w,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            docType == LegalDocType.terms ? Icons.description_outlined : Icons.privacy_tip_outlined,
            color: isDark ? AppColors.primaryLight : AppColors.primary,
            size: 32.w,
          ),
        ),
        SizedBox(height: 12.h),
        AppText.titleLarge(
          docType == LegalDocType.terms ? locale.translate('crm_terms') : locale.translate('crm_privacy'),
          fontWeight: FontWeight.w800,
        ),
      ],
    );
  }

  Widget _buildLastUpdatedBanner(bool isDark, AppLocalizations locale) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black12,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.update_rounded,
            size: 16.w,
            color: isDark ? Colors.white54 : Colors.black54,
          ),
          SizedBox(width: 8.w),
          AppText.bodySmall(
            locale.translate('last_updated'),
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentSectionCard(_DocSection section, bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6.w,
                height: 20.h,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: AppText.titleSmall(
                  section.title,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          AppText.bodyMedium(
            section.body,
            color: isDark ? Colors.white60 : Colors.black54,
            style: const TextStyle(height: 1.5),
          ),
        ],
      ),
    );
  }

  List<_DocSection> _getTermsSections() {
    return const [
      _DocSection(
        '1. Acceptance of Terms',
        'By utilizing the CRM Dashboard App application interface, you explicitly consent to compile with and be bound by these legal Terms of Service, all applicable developer APIs, and local caching protocols.',
      ),
      _DocSection(
        '2. Account Security & Session Key Management',
        'User authentication states are stored securely under local Hive box instances. You are fully responsible for preserving session keys and ensuring unauthorized devices do not capture localized access tokens.',
      ),
      _DocSection(
        '3. Organization & Lead Data Ownership',
        'All client relations records, company items, deal pipelines, and simulated metrics configured on your account dashboard remain your sole intellectual property. CRM Dashboard App does not monetize or scrape lead pipelines.',
      ),
      _DocSection(
        '4. Simulated Network SLAs',
        'Network responses, lazy loading metrics, and pagination lists simulate real-world endpoints using public APIs (e.g. JSONPlaceholder). These resources are provided for enterprise demonstration, with zero guarantees of system uptime.',
      ),
      _DocSection(
        '5. Session Termination Policies',
        'You have the complete right to terminate active application shells and clear persistent local variables at any point. Clearing your browser cache or executing a formal sign-out will instantly wipe access identifiers.',
      ),
    ];
  }

  List<_DocSection> _getPrivacySections() {
    return const [
      _DocSection(
        '1. Persistent Local Storage Encryption',
        'We value your confidentiality. Any information relating to leads, companies, or custom session credentials remains stored strictly inside a Hive DB cache on-device, fully protected by underlying OS memory boundaries.',
      ),
      _DocSection(
        '2. API Call Security Standards',
        'In order to hydrate simulated company registries, CRM Dashboard App requests standard payload packets from open endpoints via safe transport security layers (HTTPS). No credentials, session logs, or parameters are submitted to external domains.',
      ),
      _DocSection(
        '3. Exclusions of Background Analytics',
        'Our design system stands for zero diagnostic tracking. CRM Dashboard App contains no telemetry trackers, hotjar modules, or cookie monitors. Your business data remains fully isolated and visible only inside your dashboard viewport.',
      ),
      _DocSection(
        '4. Standard User Rights',
        'You possess complete rights to access, inspect, or destroy persistent local settings. Simply navigate to the Actions dashboard segment inside Settings, and click "Logout" to wipe local authentication boxes.',
      ),
      _DocSection(
        '5. Policy Evolution Notices',
        'Should we expand active syncing capabilities to enterprise clouds, we will communicate updates clearly through visual notifications before adapting localized sync architectures.',
      ),
    ];
  }
}

class _DocSection {
  final String title;
  final String body;

  const _DocSection(this.title, this.body);
}
