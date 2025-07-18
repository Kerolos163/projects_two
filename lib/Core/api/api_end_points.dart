final class ApiEndPoints {
  ApiEndPoints._();
  static const String baseUrl = "http://10.0.2.2:5000/";
  static const String login = "/api/users/Login";
  static const String forgotPassword = "api/users/forgotPassword";
  static const String verifyPassword = "api/users/verifyPassword";
  static const String resetPassword = "api/users/resetPassword";
  static const String register = "api/users/Register";
  static const String homeCategory = "api/categories";
  static const String homeProduct = "api/products";
  static const String addReview = "/api/reviews";

  static String getUserbyId({required String id}) => "api/users/$id";
  static String updateUserbyId({required String id}) => "api/users/$id";
  static String uploadImage({required String id}) =>
      "/api/users/updateImage/$id";
  static String userFavorites({required String id}) => "/api/favorites/$id";
  static String productReview({required String productId}) =>
      "/api/products/$productId/reviews";
  static String deleteReview({required String reviewId}) =>
      "/api/reviews/$reviewId";
  static String getSubCategory({required String categoryId}) =>
      "/api/categories/$categoryId/subcategories";
}
