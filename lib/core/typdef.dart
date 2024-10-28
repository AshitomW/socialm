import 'package:fpdart/fpdart.dart';
import 'package:social/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = Future<void>;
