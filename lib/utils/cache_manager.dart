import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class XCacheManager {
  static const key = 'xCacheKey';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 20,
      repo: JsonCacheInfoRepository(databaseName: key),
      //fileSystem: IOFileSystem(key),
      //fileService: HttpFileService(),
    ),
  );
}