import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/feature/auth/models/request/user_payload.dart';
import 'package:lombard/src/feature/profile/data/profile_repository.dart';

part 'profile_edit_cubit.freezed.dart';

class ProfileEditCubit extends Cubit<ProfileEditState> {
  ProfileEditCubit({
    required IProfileRepository repository,
  })  : _repository = repository,
        super(const ProfileEditState.initial());
  final IProfileRepository _repository;

  Future<void> editAccount({
    required UserPayload userPayload,
    XFile? avatar,
  }) async {
    try {
      emit(const ProfileEditState.loading());

      await _repository.editAccount(userPayload: userPayload, avatar: avatar);

      emit(const ProfileEditState.loaded());
    } on RestClientException catch (e) {
      emit(
        ProfileEditState.error(
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        ProfileEditState.error(
          message: e.toString(),
        ),
      );
    }
  }
}

@freezed
class ProfileEditState with _$ProfileEditState {
  const factory ProfileEditState.initial() = _InitialState;

  const factory ProfileEditState.loading() = _LoadingState;

  const factory ProfileEditState.loaded() = _LoadedState;

  const factory ProfileEditState.error({
    required String message,
  }) = _ErrorState;
}
