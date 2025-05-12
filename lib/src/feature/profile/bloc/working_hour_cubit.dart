import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/feature/profile/data/profile_repository.dart';
import 'package:lombard/src/feature/profile/models/response/working_hour_dto.dart';

part 'working_hour_cubit.freezed.dart';

class WorkingHourCubit extends Cubit<WorkingHourState> {
  WorkingHourCubit({
    required IProfileRepository repository,
  })  : _repository = repository,
        super(const WorkingHourState.initial());
  final IProfileRepository _repository;

  Future<void> getWorkingHour() async {
    try {
      emit(const WorkingHourState.loading());

      final result = await _repository.workingHourList();

      emit(WorkingHourState.loaded(workingHourList: result));
    } on RestClientException catch (e) {
      emit(
        WorkingHourState.error(
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        WorkingHourState.error(
          message: e.toString(),
        ),
      );
    }
  }
}

@freezed
class WorkingHourState with _$WorkingHourState {
  const factory WorkingHourState.initial() = _InitialState;

  const factory WorkingHourState.loading() = _LoadingState;

  const factory WorkingHourState.loaded({
    required List<WorkingHourDTO> workingHourList,
  }) = _LoadedState;

  const factory WorkingHourState.error({
    required String message,
  }) = _ErrorState;
}
