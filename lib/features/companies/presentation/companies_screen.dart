import 'package:flutter/material.dart';
import 'package:crm_dashboard_app/core/localization/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:crm_dashboard_app/core/constants/app_spacing.dart';
import 'package:crm_dashboard_app/core/utils/responsive_helper.dart';
import 'package:crm_dashboard_app/core/widgets/animated_search_bar.dart';
import 'package:crm_dashboard_app/core/widgets/custom_app_bar.dart';
import 'package:crm_dashboard_app/core/widgets/empty_state_widget.dart';
import 'package:crm_dashboard_app/core/widgets/error_state_widget.dart';
import 'package:crm_dashboard_app/core/widgets/shimmer_loading.dart';
import 'package:crm_dashboard_app/core/widgets/status_badge.dart';
import 'package:crm_dashboard_app/features/companies/provider/companies_provider.dart';
import 'package:crm_dashboard_app/features/companies/presentation/widgets/company_tile.dart';
import 'package:crm_dashboard_app/features/companies/data/company_model.dart';
import 'package:crm_dashboard_app/routes/app_router.dart';

class CompaniesScreen extends ConsumerStatefulWidget {
  const CompaniesScreen({super.key});

  @override
  ConsumerState<CompaniesScreen> createState() => _CompaniesScreenState();
}

class _CompaniesScreenState extends ConsumerState<CompaniesScreen> {
  bool _showLocalShimmer = true;
  late final ScrollController _scrollController;

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
        _scrollController.position.maxScrollExtent - 100) {
      ref.read(companiesProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.tr(ref);
    final companiesAsync = ref.watch(companiesProvider);
    final isPageLoading = ref.watch(companiesLoadingMoreProvider);
    final hasMore = ref.watch(companiesHasMoreProvider);
    final showShimmer =
        _showLocalShimmer || (companiesAsync.isLoading && !isPageLoading);

    return Scaffold(
      appBar: CustomAppBar(
        title: locale.translate('companies'),
        showSearch: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: AppSpacing.screenPadding,
            child: AnimatedSearchBar(
              hintText: locale.translate('search_company_hint'),
              onChanged: (val) {
                ref.read(companySearchQueryProvider.notifier).state = val;
                if (_scrollController.hasClients) {
                  _scrollController.jumpTo(0);
                }
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(companiesProvider.notifier).refresh(),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                child: showShimmer
                    ? ListView.builder(
                        key: const ValueKey('shimmer_list'),
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          bottom: AppSpacing.xxl + (ResponsiveHelper.isMobile(context) ? 120.h : 0),
                        ),
                        itemCount: 6,
                        itemBuilder: (context, index) =>
                            const CompanyTileShimmer(),
                      )
                    : companiesAsync.when(
                        data: (companies) {
                          if (companies.isEmpty) {
                            final query = ref.read(companySearchQueryProvider);
                            return ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(height: 100.h),
                                EmptyStateWidget(
                                  key: const ValueKey('empty_state'),
                                  icon: Icons.search_off_rounded,
                                  title: locale.translate('no_companies_found'),
                                  subtitle: query.isNotEmpty
                                      ? '${locale.translate('no_results_matching')} "$query"'
                                      : locale.translate('try_adjusting_search'),
                                ),
                              ],
                            );
                          }

                          return ListView.builder(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.only(
                              bottom: AppSpacing.xxl + (ResponsiveHelper.isMobile(context) ? 120.h : 0),
                            ),
                            itemCount: hasMore
                                ? companies.length + 1
                                : companies.length,
                            itemBuilder: (context, index) {
                              if (index == companies.length) {
                                return isPageLoading
                                    ? const CompanyTileShimmer()
                                    : const SizedBox.shrink();
                              }

                              final company = companies[index];
                              return _buildAnimatedTile(company, index);
                            },
                          );
                        },
                        loading: () => const SizedBox.shrink(), // Covered by parent showShimmer
                        error: (err, stack) => ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: 100.h),
                            ErrorStateWidget(
                              message: err.toString(),
                              onRetry: () =>
                                  ref.read(companiesProvider.notifier).refresh(),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedTile(CompanyModel company, int index) {
    // Assign status based on ID purely for demo
    final statusValue = company.id % 4;
    StatusType status;
    if (statusValue == 0) {
      status = StatusType.active;
    } else if (statusValue == 1) {
      status = StatusType.pending;
    } else if (statusValue == 2) {
      status = StatusType.priority;
    } else {
      status = StatusType.inactive;
    }

    return _AnimatedTileEntrance(
      index: index,
      child: CompanyTile(
        company: company,
        status: status,
        onTap: () {
          // Navigate using go_router path params
          context.push(
              AppRoutes.companyDetails.replaceAll(':id', '${company.id}'));
        },
      ),
    );
  }
}

/// A sequential sliding-fading animation for list tiles.
class _AnimatedTileEntrance extends StatefulWidget {
  final Widget child;
  final int index;

  const _AnimatedTileEntrance({
    required this.child,
    required this.index,
  });

  @override
  State<_AnimatedTileEntrance> createState() => _AnimatedTileEntranceState();
}

class _AnimatedTileEntranceState extends State<_AnimatedTileEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0.08, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: widget.index * 40), () {
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
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}
