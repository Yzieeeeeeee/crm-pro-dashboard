/// Centralized API endpoint constants.
class ApiEndpoints {
  ApiEndpoints._();

  static const String users = '/users';
  static String userById(int id) => '/users/$id';
}
