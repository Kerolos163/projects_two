import 'package:equatable/equatable.dart';

sealed class ServerException extends Equatable implements Exception {
  final dynamic message;

  const ServerException([this.message]);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => '$message';
}

final class FetchDataException extends ServerException {
  const FetchDataException([super.message]);
}

final class BadRequestException extends ServerException {
  const BadRequestException([super.message]);
}

final class UnauthorizedException extends ServerException {
  const UnauthorizedException([super.message]);
}

final class NotFoundException extends ServerException {
  const NotFoundException([super.message]);
}

final class ForbiddenException extends ServerException {
  const ForbiddenException([message]) : super('Forbidden');
}

final class ConflictException extends ServerException {
  const ConflictException([message]) : super('Conflict');
}

final class UnProcessableEntityException extends ServerException {
  const UnProcessableEntityException([super.message]);
}

final class InternalServerErrorException extends ServerException {
  const InternalServerErrorException([message])
    : super('Internal Server Error');
}

final class NoInternetException extends ServerException {
  const NoInternetException([super.message]);
}

final class CacheException implements Exception {
  final String? message;

  const CacheException({this.message});

  @override
  String toString() => '$message';
}

final class LocationException extends Equatable implements Exception {
  final String? message;
  const LocationException([this.message]);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => '$message';
}
