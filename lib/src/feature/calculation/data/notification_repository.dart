import 'package:lombard/src/core/rest_client/models/basic_response.dart';
import 'package:lombard/src/feature/calculation/data/notification_remote_ds.dart';
import 'package:lombard/src/feature/calculation/model/notification_dto.dart';

abstract interface class INotificationRepository {
  Future<List<NotificationDTO>> notificationList();

  Future<BasicResponse> readNotification({
    required int id,
  });
}

class NotificationRepositoryImpl implements INotificationRepository {
  const NotificationRepositoryImpl({
    required INotificationRemoteDS remoteDS,
  }) : _remoteDS = remoteDS;
  final INotificationRemoteDS _remoteDS;

  @override
  Future<List<NotificationDTO>> notificationList() async {
    try {
      return await _remoteDS.notificationList();
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
