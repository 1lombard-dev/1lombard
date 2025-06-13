import 'package:lombard/src/feature/loans/data/loans_remote_ds.dart';
import 'package:lombard/src/feature/loans/model/tickets_dto.dart';

abstract interface class ILoansRepository {
  Future<List<TicketsDTO>> getActiveTickets();
  Future<List<TicketsDTO>> getArchiveTickets();
  Future<TicketsDTO> getPayment({
    required String paymentType,
    required String ticketnum,
    required String ticketdate,
  });
}

class LoansRepositoryImpl implements ILoansRepository {
  const LoansRepositoryImpl({
    required ILoansRemoteDS remoteDS,
  }) : _remoteDS = remoteDS;

  final ILoansRemoteDS _remoteDS;

  @override
  Future<List<TicketsDTO>> getActiveTickets() async {
    try {
      return await _remoteDS.getActiveTickets();
    } catch (e) {
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
      return await _remoteDS.getPayment(paymentType: paymentType, ticketdate: ticketdate, ticketnum: ticketnum);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TicketsDTO>> getArchiveTickets() async {
    try {
      return await _remoteDS.getArchiveTickets();
    } catch (e) {
      rethrow;
    }
  }
}
