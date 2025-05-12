import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/feature/calculation/data/notification_repository.dart';

part 'read_notification_cubit.freezed.dart';

class ReadNotificationCubit extends Cubit<ReadNotificationState> {
  final INotificationRepository _repository;
  ReadNotificationCubit({required INotificationRepository repository})
      : _repository = repository,
        super(const ReadNotificationState.initial());

  Future<void> readNotification({
    required int id,
  }) async {
    try {
      emit(const ReadNotificationState.loading());

      await _repository.readNotification(id: id);

      emit(const ReadNotificationState.loaded());
    } on RestClientException catch (e) {
      emit(ReadNotificationState.error(message: e.message));
    } catch (e) {
      emit(ReadNotificationState.error(message: e.toString()));
    }
  }
}

@freezed
class ReadNotificationState with _$ReadNotificationState {
  const factory ReadNotificationState.initial() = _InitialState;
  const factory ReadNotificationState.loading() = _LoadingState;
  const factory ReadNotificationState.loaded() = _LoadedState;
  const factory ReadNotificationState.error({
    required String message,
  }) = _ErrorState;
}
