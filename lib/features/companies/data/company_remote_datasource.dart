import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:crm_dashboard_app/core/network/api_endpoints.dart';
import 'package:crm_dashboard_app/core/network/dio_client.dart';
import 'package:crm_dashboard_app/features/companies/data/company_model.dart';

/// Contract for fetching company data from the remote API.
abstract class CompanyRemoteDataSource {
  /// Fetches paginated companies directly from the API.
  Future<List<CompanyModel>> fetchCompanies({
    required int page,
    required int limit,
    String? query,
  });

  /// Fetches a single company by its unique ID.
  Future<CompanyModel> fetchCompanyById(int id);
}

/// Implementation of [CompanyRemoteDataSource] using [DioClient].
class CompanyRemoteDataSourceImpl implements CompanyRemoteDataSource {
  CompanyRemoteDataSourceImpl();

  @override
  Future<List<CompanyModel>> fetchCompanies({
    required int page,
    required int limit,
    String? query,
  }) async {
    final Map<String, dynamic> queryParameters = {
      '_page': page,
      '_limit': limit,
    };

    if (query != null && query.trim().isNotEmpty) {
      queryParameters['q'] = query.trim();
    }

    final response = await DioClient.instance.dio.get(
      ApiEndpoints.users,
      queryParameters: queryParameters,
    );

    final data = response.data as List<dynamic>;
    return data
        .map((json) => CompanyModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<CompanyModel> fetchCompanyById(int id) async {
    final response =
        await DioClient.instance.dio.get(ApiEndpoints.userById(id));
    return CompanyModel.fromJson(response.data as Map<String, dynamic>);
  }
}

/// Provides the [CompanyRemoteDataSource] instance.
final companyRemoteDataSourceProvider = Provider<CompanyRemoteDataSource>(
  (ref) => CompanyRemoteDataSourceImpl(),
);
