import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/feature/calculation/data/notification_repository.dart';
import 'package:lombard/src/feature/calculation/model/notification_dto.dart';

part 'notification_cubit.freezed.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final INotificationRepository _repository;
  NotificationCubit({required INotificationRepository repository})
      : _repository = repository,
        super(const NotificationState.initial());

  Future<void> getNotificationList({
    bool hasDelay = true,
    bool hasLoading = true,
  }) async {
    try {
      if (hasLoading) {
        emit(const NotificationState.loading());
      }

      if (hasDelay) {
        await Future.delayed(const Duration(milliseconds: 500));
      }

      final result = await _repository.notificationList();

      emit(NotificationState.loaded(notificationList: result));
    } on RestClientException catch (e) {
      emit(NotificationState.error(message: e.message));
    } catch (e) {
      emit(NotificationState.error(message: e.toString()));
    }
  }
}

@freezed
class NotificationState with _$NotificationState {
  const factory NotificationState.initial() = _InitialState;
  const factory NotificationState.loading() = _LoadingState;
  const factory NotificationState.loaded({
    required List<NotificationDTO> notificationList,
  }) = _LoadedState;
  const factory NotificationState.error({
    required String message,
  }) = _ErrorState;
}
