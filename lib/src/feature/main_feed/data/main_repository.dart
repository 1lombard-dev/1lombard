import 'package:lombard/src/feature/auth/database/auth_dao.dart';
import 'package:lombard/src/feature/main_feed/data/main_remote_ds.dart';
import 'package:lombard/src/feature/main_feed/model/category_dto.dart';
import 'package:lombard/src/feature/main_feed/model/main_page_dto.dart';
import 'package:lombard/src/feature/main_feed/model/question_dto.dart';

abstract interface class IMainRepository {
  Future<List<BannerDTO>> mainPageBanner();

  Future<List<CategoryDTO>> categories();

  Future<List<QuestionDTO>> getFAQ();

  Future<String> getToken();
}

class MainRepositoryImpl implements IMainRepository {
  const MainRepositoryImpl({
    required IMainRemoteDS remoteDS,
    required IAuthDao authDao,
  })  : _remoteDS = remoteDS,
        _authDao = authDao;
  final IMainRemoteDS _remoteDS;
  final IAuthDao _authDao;

  @override
  Future<List<BannerDTO>> mainPageBanner() async {
    try {
      return await _remoteDS.mainPageBanner();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CategoryDTO>> categories() async {
    try {
      return await _remoteDS.categories();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<QuestionDTO>> getFAQ() async {
    try {
      return await _remoteDS.getFAQ();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> getToken() async {
    try {
      final token = await _remoteDS.getToken();
      await _authDao.token.setValue(token);
      return token;
    } catch (e) {
      rethrow;
    }
  }
}
