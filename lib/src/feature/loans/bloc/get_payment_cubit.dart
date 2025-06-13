import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/feature/loans/data/loans_repository.dart';
import 'package:lombard/src/feature/loans/model/tickets_dto.dart';

part 'get_payment_cubit.freezed.dart';

class GetPaymentCubit extends Cubit<GetPaymentState> {
  GetPaymentCubit({
    required ILoansRepository repository,
  })  : _repository = repository,
        super(const GetPaymentState.initial());
  final ILoansRepository _repository;

  Future<void> getPayment({
    required String paymentType,
    required String ticketnum,
    required String ticketdate,
  }) async {
    try {
      emit(const GetPaymentState.loading());

      final result =
          await _repository.getPayment(paymentType: paymentType, ticketnum: ticketnum, ticketdate: ticketdate);

      emit(GetPaymentState.loaded(tickets: result));
    } on RestClientException catch (e) {
      emit(
        GetPaymentState.error(
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        GetPaymentState.error(
          message: e.toString(),
        ),
      );
    }
  }
}

@freezed
class GetPaymentState with _$GetPaymentState {
  const factory GetPaymentState.initial() = _InitialState;

  const factory GetPaymentState.loading() = _LoadingState;

  const factory GetPaymentState.loaded({
    required TicketsDTO tickets,
  }) = _LoadedState;

  const factory GetPaymentState.error({
    required String message,
  }) = _ErrorState;
}
