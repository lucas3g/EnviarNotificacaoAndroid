import 'helpers/params.dart';

abstract class LocalStorageService {
  Future<void> init(LocalStorageInitParam param);
  Future<void> create(LocalStorageCreateParam param);
  Future<void> delete(LocalStorageDeleteParam param);
  Future<List<Map<String, dynamic>>> getAll(LocalStorageGetAllParam param);
}
