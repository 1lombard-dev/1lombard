import 'package:lombard/src/core/rest_client/models/basic_response.dart';
import 'package:lombard/src/feature/calculation/data/calculation_remote_ds.dart';
import 'package:lombard/src/feature/calculation/model/gold_dto.dart';

abstract interface class ICalculationRepository {
  Future<List<GoldDTO>> getGoldList();

  Future<BasicResponse> readNotification({
    required int id,
  });
}

class CalculationRepositoryImpl implements ICalculationRepository {
  const CalculationRepositoryImpl({
    required ICalculationRemoteDS remoteDS,
  }) : _remoteDS = remoteDS;
  final ICalculationRemoteDS _remoteDS;

  @override
  Future<List<GoldDTO>> getGoldList() async {
    try {
      return await _remoteDS.getGoldList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BasicResponse> readNotification({required int id}) async {
    try {
      return await _remoteDS.readNotification(id: id);
    } catch (e) {
      rethrow;
    }
  }
}
