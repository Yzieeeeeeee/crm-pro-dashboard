import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:crm_dashboard_app/core/network/api_result.dart';
import 'package:crm_dashboard_app/features/companies/data/company_model.dart';
import 'package:crm_dashboard_app/features/companies/data/company_remote_datasource.dart';

/// Contract for the company repository layer.
abstract class CompanyRepository {
  /// Fetches companies with pagination and query-based filtering.
  Future<ApiResult<List<CompanyModel>>> getCompanies({
    required int page,
    required int limit,
    String? query,
  });

  /// Fetches a single company by ID with error mapping.
  Future<ApiResult<CompanyModel>> getCompanyById(int id);
}

/// Implementation of [CompanyRepository] with Dio error mapping.
class CompanyRepositoryImpl implements CompanyRepository {
  final CompanyRemoteDataSource _dataSource;

  CompanyRepositoryImpl(this._dataSource);

  @override
  Future<ApiResult<List<CompanyModel>>> getCompanies({
    required int page,
    required int limit,
    String? query,
  }) async {
    try {
      final data = await _dataSource.fetchCompanies(
        page: page,
        limit: limit,
        query: query,
      );
      return ApiSuccess(data);
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.connectionError:
          return const ApiFailure('No internet connection');
        case DioExceptionType.badResponse:
          final statusCode = e.response?.statusCode ?? 0;
          return ApiFailure(
            'Server error: $statusCode',
            statusCode: statusCode,
          );
        default:
          return ApiFailure(e.message ?? 'Unknown error');
      }
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }

  @override
  Future<ApiResult<CompanyModel>> getCompanyById(int id) async {
    try {
      final data = await _dataSource.fetchCompanyById(id);
      return ApiSuccess(data);
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.connectionError:
          return const ApiFailure('No internet connection');
        case DioExceptionType.badResponse:
          final statusCode = e.response?.statusCode ?? 0;
          return ApiFailure(
            'Server error: $statusCode',
            statusCode: statusCode,
          );
        default:
          return ApiFailure(e.message ?? 'Unknown error');
      }
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }
}

/// Provides the [CompanyRepository] instance.
final companyRepositoryProvider = Provider<CompanyRepository>(
  (ref) => CompanyRepositoryImpl(
    ref.watch(companyRemoteDataSourceProvider),
  ),
);
