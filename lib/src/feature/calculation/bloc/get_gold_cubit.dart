import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/feature/calculation/data/calculation_repository.dart';
import 'package:lombard/src/feature/calculation/model/gold_dto.dart';

part 'get_gold_cubit.freezed.dart';

class GetGoldCubit extends Cubit<GetGoldState> {
  final ICalculationRepository _repository;
  GetGoldCubit({required ICalculationRepository repository})
      : _repository = repository,
        super(const GetGoldState.initial());

  Future<void> getGoldList({
    bool hasDelay = true,
    bool hasLoading = true,
  }) async {
    try {
      if (hasLoading) {
        emit(const GetGoldState.loading());
      }

      if (hasDelay) {
        await Future.delayed(const Duration(milliseconds: 500));
      }

      final result = await _repository.getGoldList();

      emit(GetGoldState.loaded(goldDTO: result));
    } on RestClientException catch (e) {
      emit(GetGoldState.error(message: e.message));
    } catch (e) {
      emit(GetGoldState.error(message: e.toString()));
    }
  }
}

@freezed
class GetGoldState with _$GetGoldState {
  const factory GetGoldState.initial() = _InitialState;
  const factory GetGoldState.loading() = _LoadingState;
  const factory GetGoldState.loaded({
    required List<GoldDTO> goldDTO,
  }) = _LoadedState;
  const factory GetGoldState.error({
    required String message,
  }) = _ErrorState;
}
