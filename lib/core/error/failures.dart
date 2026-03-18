import 'package:equatable/equatable.dart';

/// Base failure class for domain-level error representation.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Failure originating from a network/API call.
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Failure originating from local storage operations.
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Failure for unexpected / unhandled errors.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}
