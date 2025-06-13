import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/feature/loans/data/loans_repository.dart';
import 'package:lombard/src/feature/loans/model/tickets_dto.dart';

part 'get_active_tickets_cubit.freezed.dart';

class GetActiveTicketsCubit extends Cubit<GetActiveTicketsState> {
  GetActiveTicketsCubit({
    required ILoansRepository repository,
  })  : _repository = repository,
        super(const GetActiveTicketsState.initial());
  final ILoansRepository _repository;

  // final List<FaqDTO> _faqList = [];

  Future<void> getActiveTickets() async {
    try {
      emit(const GetActiveTicketsState.loading());

      final result = await _repository.getActiveTickets();

      emit(GetActiveTicketsState.loaded(tickets: result));
    } on RestClientException catch (e) {
      emit(
        GetActiveTicketsState.error(
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        GetActiveTicketsState.error(
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> getArchiveTickets() async {
    try {
      emit(const GetActiveTicketsState.loading());

      final result = await _repository.getArchiveTickets();

      emit(GetActiveTicketsState.loadedArchive(ticketsArchive: result));
    } on RestClientException catch (e) {
      emit(
        GetActiveTicketsState.error(
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        GetActiveTicketsState.error(
          message: e.toString(),
        ),
      );
    }
  }
}

@freezed
class GetActiveTicketsState with _$GetActiveTicketsState {
  const factory GetActiveTicketsState.initial() = _InitialState;

  const factory GetActiveTicketsState.loading() = _LoadingState;

  const factory GetActiveTicketsState.loaded({
    required List<TicketsDTO> tickets,
  }) = _LoadedState;

    const factory GetActiveTicketsState.loadedArchive({
    required List<TicketsDTO> ticketsArchive,
  }) = _LoadedArchiveState;

  const factory GetActiveTicketsState.error({
    required String message,
  }) = _ErrorState;
}
