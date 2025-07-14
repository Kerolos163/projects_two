import 'package:dio/dio.dart';

abstract class Failure {
  final String errorMessage;

  Failure({required this.errorMessage});
}

class ServerFailure extends Failure {
  ServerFailure({required super.errorMessage});
  factory ServerFailure.fromDioExption(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(
          errorMessage: 'Connection timeout with API server',
        );

      case DioExceptionType.sendTimeout:
        return ServerFailure(errorMessage: 'sent timeout with API server');

      case DioExceptionType.receiveTimeout:
        return ServerFailure(errorMessage: 'Receive timeout with API server');

      case DioExceptionType.badCertificate:
        return ServerFailure(errorMessage: 'bad certification');

      case DioExceptionType.badResponse:
        // return ServerFailure(errorMessage: 'Bad Response');
        return ServerFailure.fromResponse(
          dioException.response!.statusCode,
          dioException.response!.data,
        );

      case DioExceptionType.cancel:
        return ServerFailure(errorMessage: 'Request to ApiServer was canceled');

      case DioExceptionType.connectionError:
        return ServerFailure(errorMessage: 'connection error');

      case DioExceptionType.unknown:
        if (dioException.message!.contains('SocketException')) {
          return ServerFailure(errorMessage: 'no internet connection');
        }
        return ServerFailure(
          errorMessage: 'unExpected error, please try again',
        );
    }
  }

  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(errorMessage: response['error']['message']);
    } else if (statusCode == 404) {
      return ServerFailure(
        errorMessage: 'Your request not found, please try again later',
      );
    } else if (statusCode == 500) {
      return ServerFailure(
        errorMessage: 'internal server, please try again later',
      );
    } else {
      return ServerFailure(
        errorMessage: 'Opps There was an Error, Please try again',
      );
    }
  }
}
