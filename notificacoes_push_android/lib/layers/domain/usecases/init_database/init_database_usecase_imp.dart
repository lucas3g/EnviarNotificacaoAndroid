import 'package:dartz/dartz.dart';
import 'package:notificacoes_push_android/layers/domain/repositories/init_database_repository.dart';
import 'package:notificacoes_push_android/layers/domain/usecases/init_database/init_database_usecase.dart';
import 'package:sqflite/sqflite.dart';

class InitDatabaseUseCaseImp implements InitDatabaseUseCase {
  final InitDatabaseRepository _initDatabaseRepository;

  InitDatabaseUseCaseImp(this._initDatabaseRepository);

  @override
  Future<Either<Exception, Database>> call() async {
    return await _initDatabaseRepository();
  }
}
