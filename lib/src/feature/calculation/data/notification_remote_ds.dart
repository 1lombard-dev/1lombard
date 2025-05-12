import 'package:flutter/foundation.dart';
import 'package:lombard/src/core/rest_client/models/basic_response.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/core/utils/talker_logger_util.dart';
import 'package:lombard/src/feature/calculation/model/notification_dto.dart';

abstract interface class INotificationRemoteDS {
  Future<List<NotificationDTO>> notificationList();

  Future<BasicResponse> readNotification({
    required int id,
  });
}

class NotificationRemoteDSImpl implements INotificationRemoteDS {
  const NotificationRemoteDSImpl({
    required this.restClient,
  });
  final IRestClient restClient;

  @override
  Future<List<NotificationDTO>> notificationList() async {
    try {
      final Map<String, dynamic> response = await restClient.get(
        '/notification/get',
        queryParams: {},
      );

      if (response['data'] == null) {
        throw Exception();
      }
      final list = await compute<List<dynamic>, List<NotificationDTO>>(
        (list) => list
            .map(
              (e) => NotificationDTO.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        response['data'] as List,
      );
      return list;
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#getNotificationList - $e', e, st);
      rethrow;
    }
  }

  @override
  Future<BasicResponse> readNotification({required int id}) async {
    try {
      final Map<String, dynamic> response = await restClient.get(
        '/notification/$id/read',
        queryParams: {},
      );

      return BasicResponse.fromJson(response);
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#readNotification - $e', e, st);
      rethrow;
    }
  }
}
