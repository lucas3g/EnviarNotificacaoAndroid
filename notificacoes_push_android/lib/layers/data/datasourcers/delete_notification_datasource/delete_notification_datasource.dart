import 'package:dartz/dartz.dart';

abstract class DeleteNotificationDataSource {
  Future<Either<Exception, bool>> call({required int id});
}
