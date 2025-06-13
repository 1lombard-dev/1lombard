import 'package:flutter/foundation.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/core/utils/talker_logger_util.dart';
import 'package:lombard/src/feature/auth/database/auth_dao.dart';
import 'package:lombard/src/feature/loans/model/tickets_dto.dart';

import 'package:lombard/src/feature/settings/data/app_settings_datasource.dart';

abstract interface class ILoansRemoteDS {
  Future<List<TicketsDTO>> getActiveTickets();
  Future<List<TicketsDTO>> getArchiveTickets();
  Future<TicketsDTO> getPayment({
    required String paymentType,
    required String ticketnum,
    required String ticketdate,
  });
}

class LoansRemoteDSImpl implements ILoansRemoteDS {
  const LoansRemoteDSImpl({
    required this.restClient,
    required this.authDao,
    required this.appSettingsDatasource, // ✅ Add this
  });
  final IRestClient restClient;
  final IAuthDao authDao;
  final AppSettingsDatasource appSettingsDatasource; // ✅ Declare this

  @override
  Future<List<TicketsDTO>> getActiveTickets() async {
    try {
      final token = authDao.token.value;
      final iin = authDao.iin.value;
      final Map<String, dynamic> response = await restClient.post(
        '/webservice/tickets/getActiveTickets.php',
        body: {
          'token': token ?? '',
          'login': iin,
        },
      );

      if (response['data'] == null) {
        throw Exception();
      }
      final list = await compute<List<dynamic>, List<TicketsDTO>>(
        (list) => list
            .map(
              (e) => TicketsDTO.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        response['data'] as List,
      );
      return list;
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#getNews - $e', e, st);
      rethrow;
    }
  }

  @override
  Future<TicketsDTO> getPayment({
    required String paymentType,
    required String ticketnum,
    required String ticketdate,
  }) async {
    try {
      final token = authDao.token.value;
      final iin = authDao.iin.value;
      final appSettings = await appSettingsDatasource.getAppSettings();
      final Map<String, dynamic> response = await restClient.post(
        '/webservice/payment/getPayLinkPageNew.php',
        body: {
          'token': token ?? '',
          'login': iin ?? '',
          'lang': appSettings?.locale?.languageCode == 'kk' ? 'kz' : 'ru',
          'operationtype': paymentType,
          'ticketnum': ticketnum,
          'ticketdate': ticketdate,
        },
      );

      final dynamic data = response['data'];

      if (data is List && data.isNotEmpty && data.first is Map<String, dynamic>) {
        return TicketsDTO.fromJson(data.first as Map<String, dynamic>);
      } else {
        throw Exception('Некорректный формат данных платежки');
      }
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#getPayment - $e', e, st);
      rethrow;
    }
  }

  @override
  Future<List<TicketsDTO>> getArchiveTickets() async {
    try {
      final token = authDao.token.value;
      final iin = authDao.iin.value;
      final Map<String, dynamic> response = await restClient.post(
        '/webservice/tickets/getArchiveTickets.php',
        body: {
          'token': token ?? '',
          'login': iin,
        },
      );

      if (response['data'] == null) {
        throw Exception();
      }
      final list = await compute<List<dynamic>, List<TicketsDTO>>(
        (list) => list
            .map(
              (e) => TicketsDTO.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        response['data'] as List,
      );
      return list;
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#getNews - $e', e, st);
      rethrow;
    }
  }
}
