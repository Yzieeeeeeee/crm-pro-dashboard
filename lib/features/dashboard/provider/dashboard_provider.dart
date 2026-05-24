import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:crm_dashboard_app/features/companies/provider/companies_provider.dart';
import 'package:crm_dashboard_app/features/dashboard/data/dashboard_model.dart';
import 'package:crm_dashboard_app/features/dashboard/data/dashboard_feed_model.dart';

/// Provides the four main KPI (Key performance indicator )cards for the dashboard.
final dashboardKpiProvider = FutureProvider<List<KpiMetric>>((ref) async {
  // Watch the companies list reactively!
  final companiesAsync = ref.watch(companiesProvider);
  final companies = companiesAsync.valueOrNull ?? [];

  // Use a base of 238 plus actual loaded companies to yield exactly 248,
  // and update dynamically if the list length changes!
  final count = companies.isNotEmpty ? (238 + companies.length) : 248;

  return [
    KpiMetric(
      title: 'total_companies',
      value: count.toString(),
      icon: Icons.business_rounded,
      trend: 12.5,
      color: const Color(0xFF4F46E5),
      gradientColors: const [Color(0xFF4F46E5), Color(0xFF7C3AED)],
    ),
    const KpiMetric(
      title: 'total_revenue',
      value: '\$1.2M',
      icon: Icons.attach_money_rounded,
      trend: 8.3,
      color: Color(0xFF059669),
      gradientColors: [Color(0xFF059669), Color(0xFF34D399)],
    ),
    const KpiMetric(
      title: 'active_leads',
      value: '64',
      icon: Icons.handshake_rounded,
      trend: 23.1,
      color: Color(0xFF7C3AED),
      gradientColors: [Color(0xFF7C3AED), Color(0xFFA78BFA)],
    ),
    const KpiMetric(
      title: 'conversion_rate',
      value: '18.2%',
      icon: Icons.trending_up_rounded,
      trend: -2.4,
      color: Color(0xFFD97706),
      gradientColors: [Color(0xFFD97706), Color(0xFFF59E0B)],
    ),
  ];
});

/// Provides the full pool of recent activity items (backing data source).
/// Generates 40+ activities by cycling through companies with varied action types.
final _allActivitiesProvider = FutureProvider<List<Activity>>((ref) async {
  // Properly await companies data instead of reading sync AsyncValue
  final companies = await ref.watch(companiesProvider.future);

  // Wait a small delay to feel premium and avoid immediate snap
  await Future<void>.delayed(const Duration(milliseconds: 300));

  if (companies.isEmpty) {
    return const [];
  }

  final now = DateTime.now();
  final List<Activity> list = [];

  // 4 rounds of activity generation per company for the scrolling data ,added dummy datas
  final rounds = [
    {
      'titles': ['New deal created', 'Meeting completed', 'Proposal sent', 'Task completed', 'Deal closed',
                 'Follow-up scheduled', 'Contract signed', 'Call completed', 'Invoice paid', 'Onboarding completed'],
      'types': [ActivityType.deal, ActivityType.meeting, ActivityType.email, ActivityType.task, ActivityType.deal,
                ActivityType.meeting, ActivityType.email, ActivityType.task, ActivityType.deal, ActivityType.task],
      'descTemplates': {
        ActivityType.deal: (c, i) => 'Enterprise subscription for ${c.companyName} — \$${(i + 1) * 15},000',
        ActivityType.meeting: (c, i) => 'Quarterly pipeline sync with ${c.contactName}',
        ActivityType.email: (c, i) => 'Sent custom pricing sheet to ${c.email}',
        ActivityType.task: (c, i) => 'Updated CRM pipeline stage for ${c.companyName}',
      },
    },
    {
      'titles': ['Revenue milestone reached', 'Client review session', 'Renewal notice sent', 'Dashboard updated',
                 'Partnership signed', 'Team sync call', 'Quote delivered', 'Support ticket resolved', 'Payment received', 'Demo scheduled'],
      'types': [ActivityType.deal, ActivityType.meeting, ActivityType.email, ActivityType.task, ActivityType.deal,
                ActivityType.meeting, ActivityType.email, ActivityType.task, ActivityType.deal, ActivityType.meeting],
      'descTemplates': {
        ActivityType.deal: (c, i) => '${c.companyName} crossed \$${(i + 2) * 25}K revenue target',
        ActivityType.meeting: (c, i) => 'Stakeholder alignment call with ${c.contactName}',
        ActivityType.email: (c, i) => 'Renewal reminder sent to ${c.email}',
        ActivityType.task: (c, i) => 'Refreshed analytics dashboard for ${c.companyName}',
      },
    },
    {
      'titles': ['Upsell opportunity flagged', 'Strategy workshop', 'Feedback request sent', 'Compliance check done',
                 'Contract amended', 'Quarterly review booked', 'Invoice dispatched', 'SLA review completed', 'Budget approved', 'Kickoff meeting set'],
      'types': [ActivityType.deal, ActivityType.meeting, ActivityType.email, ActivityType.task, ActivityType.deal,
                ActivityType.meeting, ActivityType.email, ActivityType.task, ActivityType.deal, ActivityType.meeting],
      'descTemplates': {
        ActivityType.deal: (c, i) => 'Premium tier upsell identified for ${c.companyName}',
        ActivityType.meeting: (c, i) => 'Workshop session planned with ${c.contactName}\'s team',
        ActivityType.email: (c, i) => 'NPS survey request sent to ${c.email}',
        ActivityType.task: (c, i) => 'Compliance checklist completed for ${c.companyName}',
      },
    },
    {
      'titles': ['Lead converted', 'Exec alignment call', 'Case study drafted', 'Integration configured',
                 'Pilot launched', 'Roadmap shared', 'Billing updated', 'Risk assessment done', 'Expansion deal', 'Handoff completed'],
      'types': [ActivityType.deal, ActivityType.meeting, ActivityType.email, ActivityType.task, ActivityType.deal,
                ActivityType.meeting, ActivityType.email, ActivityType.task, ActivityType.deal, ActivityType.task],
      'descTemplates': {
        ActivityType.deal: (c, i) => 'Converted ${c.companyName} from trial to paid — \$${(i + 1) * 8},500',
        ActivityType.meeting: (c, i) => 'Executive sync with ${c.contactName} on expansion',
        ActivityType.email: (c, i) => 'Drafted success story featuring ${c.companyName}',
        ActivityType.task: (c, i) => 'Completed API integration setup for ${c.companyName}',
      },
    },
  ];

  int activityIndex = 0;
  for (int round = 0; round < rounds.length; round++) {
    final r = rounds[round];
    final titles = r['titles'] as List<String>;
    final types = r['types'] as List<ActivityType>;
    final descTemplates = r['descTemplates'] as Map<ActivityType, String Function(dynamic, int)>;

    for (int i = 0; i < companies.length; i++) {
      final company = companies[i];
      final title = titles[i % titles.length];
      final type = types[i % types.length];
      final descFn = descTemplates[type]!;
      final desc = descFn(company, i);

      list.add(Activity(
        id: 'activity_r${round}_${company.id}',
        title: title,
        description: desc,
        timestamp: now.subtract(Duration(hours: activityIndex * 3 + 1)),
        type: type,
        userName: company.contactName,
      ));
      activityIndex++;
    }
  }

  return list;
});

/// State for the unified paginated feed on the dashboard.
class DashboardFeedState {
  final List<DashboardFeedItem> items;
  final bool isLoadingMore;
  final bool hasMore;
  final bool isInitialLoading;

  // Trackers for pagination across different sources
  final int activityOffset;
  final int meetingOffset;
  final int companyOffset;

  const DashboardFeedState({
    this.items = const [],
    this.isLoadingMore = false,
    this.hasMore = true,
    this.isInitialLoading = true,
    this.activityOffset = 0,
    this.meetingOffset = 0,
    this.companyOffset = 0,
  });

  DashboardFeedState copyWith({
    List<DashboardFeedItem>? items,
    bool? isLoadingMore,
    bool? hasMore,
    bool? isInitialLoading,
    int? activityOffset,
    int? meetingOffset,
    int? companyOffset,
  }) {
    return DashboardFeedState(
      items: items ?? this.items,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      activityOffset: activityOffset ?? this.activityOffset,
      meetingOffset: meetingOffset ?? this.meetingOffset,
      companyOffset: companyOffset ?? this.companyOffset,
    );
  }
}

/// Manages paginated unified feed loading for infinite scroll on dashboard.
class DashboardFeedNotifier extends StateNotifier<DashboardFeedState> {
  final Ref _ref;

  DashboardFeedNotifier(this._ref) : super(const DashboardFeedState()) {
    // Listen for the backing data providers to resolve
    _ref.listen<AsyncValue<List<Activity>>>(_allActivitiesProvider, (prev, next) {
      next.whenData((allActivities) {
        if (allActivities.isNotEmpty && state.items.isEmpty && !state.isLoadingMore) {
          _loadInitial();
        }
      });
    });
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    try {
      final allActivities = await _ref.read(_allActivitiesProvider.future);
      if (allActivities.isNotEmpty && mounted) {
        // Build first page directly
        final meetings = await _ref.read(upcomingMeetingsProvider.future);
        final companies = await _ref.read(companiesProvider.future);
        
        final List<DashboardFeedItem> initialItems = [];
        
        // Block 1: 3 Activities, 1 Meeting, 1 Company
        initialItems.addAll(allActivities.take(3).map((a) => FeedActivityItem(a)));
        if (meetings.isNotEmpty) initialItems.add(FeedMeetingItem(meetings.first));
        if (companies.isNotEmpty) initialItems.add(FeedCompanyItem(companies.first));
        
        if (!mounted) return;
        state = DashboardFeedState(
          items: initialItems,
          hasMore: allActivities.length > 3,
          isInitialLoading: false,
          activityOffset: 3,
          meetingOffset: 1,
          companyOffset: 1,
        );
      }
    } catch (_) {
      // Will be retried via ref.listen when data becomes available
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    // Simulate network delay for premium feel
    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    // Await the latest data from backing providers
    final allActivities = await _ref.read(_allActivitiesProvider.future);
    final allMeetings = await _ref.read(upcomingMeetingsProvider.future);
    final allCompanies = await _ref.read(companiesProvider.future);
    
    final List<DashboardFeedItem> newItems = [];
    
    // Chunk configuration
    final int activitiesToTake = 4;
    final int meetingsToTake = 1;
    final int companiesToTake = 2;

    int newActOffset = state.activityOffset;
    int newMeetOffset = state.meetingOffset;
    int newCompOffset = state.companyOffset;

    // Take activities
    final nextActivities = allActivities.skip(newActOffset).take(activitiesToTake).toList();
    newItems.addAll(nextActivities.map((a) => FeedActivityItem(a)));
    newActOffset += nextActivities.length;

    // Optional section header if we fetched activities
    if (newActOffset == 7) {
      newItems.add(const FeedSectionHeader('Earlier Today'));
    } else if (newActOffset == 15) {
      newItems.add(const FeedSectionHeader('Yesterday'));
    }

    // Interleave meeting
    final nextMeetings = allMeetings.skip(newMeetOffset).take(meetingsToTake).toList();
    if (nextMeetings.isNotEmpty) {
      newItems.add(FeedMeetingItem(nextMeetings.first));
      newMeetOffset += nextMeetings.length;
    }

    // Interleave companies
    final nextCompanies = allCompanies.skip(newCompOffset).take(companiesToTake).toList();
    for (var company in nextCompanies) {
      newItems.add(FeedCompanyItem(company));
    }
    newCompOffset += nextCompanies.length;

    if (!mounted) return;

    state = DashboardFeedState(
      items: [...state.items, ...newItems],
      isLoadingMore: false,
      hasMore: newActOffset < allActivities.length,
      isInitialLoading: false,
      activityOffset: newActOffset,
      meetingOffset: newMeetOffset,
      companyOffset: newCompOffset,
    );
  }

  Future<void> refresh() async {
    if (!mounted) return;
    state = const DashboardFeedState();
    _ref.invalidate(_allActivitiesProvider);
    await _loadInitial();
  }
}

/// Paginated unified feed provider.
final dashboardFeedProvider =
    StateNotifierProvider<DashboardFeedNotifier, DashboardFeedState>((ref) {
  return DashboardFeedNotifier(ref);
});

/// Provides upcoming meeting entries.
final upcomingMeetingsProvider = FutureProvider<List<Meeting>>((ref) async {
  final companiesAsync = ref.watch(companiesProvider);
  final companies = companiesAsync.valueOrNull ?? [];

  // Wait a small delay to feel premium
  await Future<void>.delayed(const Duration(milliseconds: 300));

  if (companies.isEmpty) {
    return const [];
  }

  final today = DateTime.now();
  final List<Meeting> list = [];

  final meetingTitles = [
    'Product Demo & Pitch',
    'Contract & SLA Review',
    'Technical Q&A Session',
    'Executive Partnership Alignment',
    'Enterprise Pricing Negotiation',
  ];

  final meetingTypes = [
    'Video Call',
    'In Person',
    'Video Call',
    'Phone Call',
    'In Person',
  ];

  // Map first 5 companies to upcoming meetings
  final count = companies.length > 5 ? 5 : companies.length;
  for (int i = 0; i < count; i++) {
    final company = companies[i];
    final title = meetingTitles[i % meetingTitles.length];
    final type = meetingTypes[i % meetingTypes.length];
    
    final time = DateTime(
      today.year, 
      today.month, 
      today.day + (i >= 2 ? 1 : 0),
      10 + (i * 2) % 6, 
      30
    );

    list.add(Meeting(
      id: 'meeting_${company.id}',
      title: title,
      contactName: company.contactName,
      time: time,
      type: type,
      avatarInitials: company.initials,
    ));
  }

  return list;
});

/// Provides monthly revenue data-points for the bar chart.
final revenueChartProvider = FutureProvider<List<ChartDataPoint>>((ref) async {
  await Future<void>.delayed(const Duration(milliseconds: 800));

  return const [
    ChartDataPoint(label: 'Jan', value: 42),
    ChartDataPoint(label: 'Feb', value: 38),
    ChartDataPoint(label: 'Mar', value: 55),
    ChartDataPoint(label: 'Apr', value: 48),
    ChartDataPoint(label: 'May', value: 62),
    ChartDataPoint(label: 'Jun', value: 58),
    ChartDataPoint(label: 'Jul', value: 72),
  ];
});