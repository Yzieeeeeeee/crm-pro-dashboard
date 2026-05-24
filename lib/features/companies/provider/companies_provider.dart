import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:crm_dashboard_app/core/network/api_result.dart';
import 'package:crm_dashboard_app/features/companies/data/company_model.dart';
import 'package:crm_dashboard_app/features/companies/data/company_repository.dart';

/// Search query state for filtering the companies list.
final companySearchQueryProvider = StateProvider<String>((_) => '');

/// Tracks if we are currently loading the next page of companies.
final companiesLoadingMoreProvider = StateProvider<bool>((_) => false);

/// Async notifier that manages the companies list state with API-level paging.
class CompaniesNotifier extends AsyncNotifier<List<CompanyModel>> {
  int _currentPage = 1;
  static const int _limit = 100; // Load all companies (no artificial limit)
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  @override
  Future<List<CompanyModel>> build() async {
    final query = ref.watch(companySearchQueryProvider);
    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;

    // Soft debounce delay for query inputs to feel elegant
    if (query.isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 150));
    }

    return _fetchPage(1, query);
  }

  Future<List<CompanyModel>> _fetchPage(int page, String query) async {
    // Add 1 second simulated network latency to show the shimmers realistically
    await Future.delayed(const Duration(milliseconds: 1000));
    final repository = ref.read(companyRepositoryProvider);
    final result = await repository.getCompanies(
      page: page,
      limit: _limit,
      query: query,
    );
    switch (result) {
      case ApiSuccess<List<CompanyModel>>(:final data):
        if (data.length < _limit) {
          _hasMore = false;
        }
        return data;
      case ApiFailure<List<CompanyModel>>(:final message):
        throw Exception(message);
    }
  }

  /// Fetches the next page of companies and appends them to the current list.
  Future<void> loadMore() async {
    if (!_hasMore || _isLoadingMore || state.isLoading || state.isRefreshing) {
      return;
    }

    _isLoadingMore = true;
    ref.read(companiesLoadingMoreProvider.notifier).state = true;

    final currentList = state.valueOrNull ?? [];
    final query = ref.read(companySearchQueryProvider);

    try {
      final nextPage = _currentPage + 1;

      // Add 1 second simulated pagination delay to show the bottom shimmer realistically
      await Future.delayed(const Duration(milliseconds: 1000));

      final repository = ref.read(companyRepositoryProvider);
      final result = await repository.getCompanies(
        page: nextPage,
        limit: _limit,
        query: query,
      );

      switch (result) {
        case ApiSuccess<List<CompanyModel>>(:final data):
          _currentPage = nextPage;
          if (data.length < _limit) {
            _hasMore = false;
          }
          state = AsyncValue.data([...currentList, ...data]);
          break;
        case ApiFailure<List<CompanyModel>>():
          _hasMore = false;
          break;
      }
    } catch (e) {
      _hasMore = false;
    } finally {
      _isLoadingMore = false;
      ref.read(companiesLoadingMoreProvider.notifier).state = false;
    }
  }

  /// Re-fetches the initial page of companies.
  Future<void> refresh() async {
    final query = ref.read(companySearchQueryProvider);
    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;
    state = const AsyncLoading();
    // Add 1.5 seconds simulated delay for pull-to-refresh loading realism
    await Future.delayed(const Duration(milliseconds: 1500));
    state = await AsyncValue.guard(() => _fetchPage(1, query));
  }
}

/// Provides the companies list as an [AsyncValue].
final companiesProvider =
    AsyncNotifierProvider<CompaniesNotifier, List<CompanyModel>>(
  CompaniesNotifier.new,
);

/// Exposes the hasMore state of the CompaniesNotifier.
final companiesHasMoreProvider = Provider<bool>((ref) {
  final notifier = ref.watch(companiesProvider.notifier);
  return notifier.hasMore;
});

/// Fetches details for a single company by ID, checking the loaded cache first.
final companyDetailsProvider =
    FutureProvider.family<CompanyModel, int>((ref, id) async {
  // 1. Try to find the company in the active loaded companies list first to avoid API hit
  final cachedList = ref.read(companiesProvider).valueOrNull;
  if (cachedList != null) {
    try {
      return cachedList.firstWhere((c) => c.id == id);
    } catch (_) {
      // Not in cache, fall through to fetch from API
    }
  }

  // 2. Not in cache, fetch it directly from the repository
  final repository = ref.read(companyRepositoryProvider);
  final result = await repository.getCompanyById(id);
  switch (result) {
    case ApiSuccess<CompanyModel>(:final data):
      return data;
    case ApiFailure<CompanyModel>(:final message):
      throw Exception(message);
  }
});
