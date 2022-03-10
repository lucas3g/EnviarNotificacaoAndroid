import 'package:dartz/dartz.dart';

abstract class DeleteNotificationUseCase {
  Future<Either<Exception, bool>> call({required int id});
}
