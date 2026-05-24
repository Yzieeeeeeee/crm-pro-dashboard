import 'package:flutter/material.dart';
import 'package:crm_dashboard_app/core/localization/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:crm_dashboard_app/core/constants/app_colors.dart';
import 'package:crm_dashboard_app/core/constants/app_radius.dart';
import 'package:crm_dashboard_app/core/constants/app_spacing.dart';
import 'package:crm_dashboard_app/core/widgets/shimmer_loading.dart';
import 'package:crm_dashboard_app/core/widgets/custom_app_bar.dart';
import 'package:crm_dashboard_app/features/dashboard/provider/dashboard_provider.dart';
import 'package:crm_dashboard_app/features/dashboard/data/dashboard_feed_model.dart';
import 'package:crm_dashboard_app/features/dashboard/presentation/widgets/feed_company_card.dart';
import 'package:crm_dashboard_app/features/dashboard/presentation/widgets/kpi_card.dart';
import 'package:crm_dashboard_app/features/dashboard/presentation/widgets/revenue_chart.dart';
import 'package:crm_dashboard_app/features/dashboard/presentation/widgets/quick_actions.dart';
import 'package:crm_dashboard_app/features/dashboard/presentation/widgets/activity_timeline.dart';
import 'package:crm_dashboard_app/features/dashboard/presentation/widgets/meetings_list.dart';
import 'package:crm_dashboard_app/features/auth/provider/auth_provider.dart';

/// Highly optimized adaptive CRM dashboard screen utilizing clean architecture and Riverpod.
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late final ScrollController _scrollController;
  bool _showLocalShimmer = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    
    // Let the skeleton shimmer float elegantly for 600ms for high-end SaaS response feel
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _showLocalShimmer = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(dashboardFeedProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.tr(ref);
    final kpisAsync = ref.watch(dashboardKpiProvider);
    final feedState = ref.watch(dashboardFeedProvider);
    final chartAsync = ref.watch(revenueChartProvider);

    final showGlobalShimmer = _showLocalShimmer ||
        kpisAsync.isLoading ||
        chartAsync.isLoading ||
        feedState.isInitialLoading;

    final authState = ref.watch(authProvider);
    final user = authState.user;
    final firstName = user != null ? user.name.split(' ').first : 'Yasir';

    final hour = DateTime.now().hour;
    String greeting = locale.translate('good_evening');
    if (hour < 12) {
      greeting = locale.translate('good_morning');
    } else if (hour < 17) {
      greeting = locale.translate('good_afternoon');
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget body = CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: AppSpacing.screenPadding.copyWith(bottom: 0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // ── KPIs Grid ─────────────────────────────────────
              showGlobalShimmer
                  ? const DashboardShimmer()
                  : kpisAsync.when(
                      data: (kpis) {
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: MediaQuery.of(context).size.width >= 700 ? 4 : 2,
                            mainAxisSpacing: AppSpacing.md,
                            crossAxisSpacing: AppSpacing.md,
                            childAspectRatio: 1.25,
                          ),
                          itemCount: kpis.length,
                          itemBuilder: (context, index) {
                            final metric = kpis[index];
                            return _AnimatedEntrance(
                              index: index,
                              child: KpiCard(
                                metric: metric,
                                onTap: () {
                                  if (metric.title == 'total_companies') {
                                    StatefulNavigationShell.of(context).goBranch(1);
                                  }
                                },
                              ),
                            );
                          },
                        );
                      },
                      loading: () => const DashboardShimmer(),
                      error: (err, stack) => Center(
                        child: Text(
                          'Error loading KPIs: $err',
                          style: const TextStyle(color: AppColors.error),
                        ),
                      ),
                    ),
              AppSpacing.gapLg,

              // ── Revenue Chart ─────────────────────────────────
              _SectionHeader(title: locale.translate('revenue_analytics'), viewAllLabel: locale.translate('view_all')),
              AppSpacing.gapSm,
              showGlobalShimmer
                  ? const ShimmerLoading(height: 300)
                  : chartAsync.when(
                      data: (data) => _AnimatedEntrance(
                        index: 4,
                        child: RevenueChart(data: data),
                      ),
                      loading: () => const ShimmerLoading(height: 300),
                      error: (err, stack) => Text('Error: $err'),
                    ),
              AppSpacing.gapLg,

              // ── Quick Actions ─────────────────────────────────
              _SectionHeader(title: locale.translate('quick_actions'), viewAllLabel: locale.translate('view_all')),
              AppSpacing.gapSm,
              const _AnimatedEntrance(
                index: 5,
                child: QuickActions(isVertical: false), // Horizontal layout for the feed
              ),
              AppSpacing.gapLg,

              // ── Unified Feed Header ───────────────────────────
              _SectionHeader(
                title: locale.translate('recent_activity'),
                viewAllLabel: locale.translate('view_all'),
                onViewAll: () {},
              ),
              AppSpacing.gapSm,
            ]),
          ),
        ),

        // ── Unified Feed Slivers ───────────────────────────
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.left),
          sliver: _buildFeedSliver(feedState, locale, showGlobalShimmer, isDark),
        ),
        
        // Bottom padding for mobile
        SliverPadding(padding: EdgeInsets.only(bottom: 120.h)),
      ],
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: locale.translate('overview'),
        subtitle: '$greeting, $firstName',
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 1500));
          ref.invalidate(dashboardKpiProvider);
          ref.read(dashboardFeedProvider.notifier).refresh();
          ref.invalidate(revenueChartProvider);
        },
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: body,
          ),
        ),
      ),
    );
  }

  Widget _buildFeedSliver(DashboardFeedState state, AppLocalizations locale, bool showGlobalShimmer, bool isDark) {
    if (showGlobalShimmer || (state.isInitialLoading && state.items.isEmpty)) {
      return const SliverToBoxAdapter(child: TimelineShimmer());
    }

    if (state.items.isEmpty && !state.isInitialLoading) {
      return SliverToBoxAdapter(
        child: _EmptySection(
          icon: Icons.history_rounded,
          label: locale.translate('no_recent_activities'),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == state.items.length) {
            return _buildLoadingIndicator(state, locale, isDark);
          }

          final item = state.items[index];
          if (item is FeedActivityItem) {
            return ActivityTile(
              key: ValueKey(item.activity.id),
              activity: item.activity,
              isLast: false,
              index: index % 5,
            );
          } else if (item is FeedMeetingItem) {
            return MeetingTile(
              key: ValueKey(item.meeting.id),
              meeting: item.meeting,
            );
          } else if (item is FeedCompanyItem) {
            return FeedCompanyCard(
              key: ValueKey(item.company.id),
              company: item.company,
            );
          } else if (item is FeedSectionHeader) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: _SectionHeader(title: item.title, viewAllLabel: ''),
            );
          }
          return const SizedBox.shrink();
        },
        childCount: state.items.length + 1,
      ),
    );
  }

  Widget _buildLoadingIndicator(DashboardFeedState state, AppLocalizations locale, bool isDark) {
    if (state.isLoadingMore) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 16.w,
              height: 16.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'Loading more...',
              style: TextStyle(
                fontSize: 12.sp,
                color: isDark ? AppColors.darkTextSecondary : AppColors.gray500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (!state.hasMore && state.items.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 16.w,
              color: AppColors.success.withValues(alpha: 0.6),
            ),
            SizedBox(width: 8.w),
            Text(
              locale.translate('activity_synced'),
              style: TextStyle(
                fontSize: 12.sp,
                color: isDark ? AppColors.darkTextSecondary : AppColors.gray500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    // Scroll hint
    if (state.hasMore && !state.isLoadingMore && state.items.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
        child: Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 24.w,
          color: (isDark ? AppColors.darkTextSecondary : AppColors.gray400).withValues(alpha: 0.5),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String viewAllLabel;
  final VoidCallback? onViewAll;

  const _SectionHeader({
    required this.title,
    this.viewAllLabel = 'View All',
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 4.w,
              height: 16.h,
              decoration: BoxDecoration(
                color: isDark ? AppColors.primaryLight : AppColors.primary,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
            ),
          ],
        ),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              viewAllLabel,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.primaryLight : AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }
}

/// Dynamic inner empty state section block
class _EmptySection extends StatelessWidget {
  final IconData icon;
  final String label;

  const _EmptySection({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: AppRadius.borderRadiusMd,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 24.w,
            color: isDark ? AppColors.darkTextSecondary.withValues(alpha: 0.5) : AppColors.gray400,
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: isDark ? AppColors.darkTextSecondary : AppColors.gray500,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// A high-fidelity animated widget to stagger children loading.
class _AnimatedEntrance extends StatefulWidget {
  final Widget child;
  final int index;

  const _AnimatedEntrance({
    required this.child,
    required this.index,
  });

  @override
  State<_AnimatedEntrance> createState() => _AnimatedEntranceState();
}

class _AnimatedEntranceState extends State<_AnimatedEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<Offset> _slide;

  static const _delay = Duration(milliseconds: 30);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.97, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutQuart),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.03),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutQuart));

    Future.delayed(_delay * widget.index, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: SlideTransition(
          position: _slide,
          child: widget.child,
        ),
      ),
    );
  }
}
