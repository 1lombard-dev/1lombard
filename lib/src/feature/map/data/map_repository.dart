import 'package:lombard/src/feature/main_feed/model/main_page_dto.dart';
import 'package:lombard/src/feature/map/data/map_remote_ds.dart';

abstract interface class IMapRepository {
  Future<List<LayersDTO>> getCity();
  Future<List<LayersDTO>> getCityDetail({required String name});
}

class MapRepositoryImpl implements IMapRepository {
  const MapRepositoryImpl({
    required IMapRemoteDS remoteDS,
  }) : _remoteDS = remoteDS;

  final IMapRemoteDS _remoteDS;

  @override
  Future<List<LayersDTO>> getCity() async {
    try {
      return await _remoteDS.getCity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<LayersDTO>> getCityDetail({required String name}) async {
    try {
      return await _remoteDS.getCityDetail(name: name);
    } catch (e) {
      rethrow;
    }
  }
}
