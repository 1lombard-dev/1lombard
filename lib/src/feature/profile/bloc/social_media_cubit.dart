import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/feature/profile/data/profile_repository.dart';
import 'package:lombard/src/feature/profile/models/response/social_media_dto.dart';

part 'social_media_cubit.freezed.dart';

class SocialMediaCubit extends Cubit<SocialMediaState> {
  SocialMediaCubit({
    required IProfileRepository repository,
  })  : _repository = repository,
        super(const SocialMediaState.initial());
  final IProfileRepository _repository;

  // List<SocialMediaDTO> _socialMediaList = [];

  Future<void> getSocialMediaList() async {
    try {
      emit(const SocialMediaState.loading());

      final result = await _repository.socialMediaList();
      emit(SocialMediaState.loaded(socialMediaList: result));
    } on RestClientException catch (e) {
      emit(
        SocialMediaState.error(
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        SocialMediaState.error(
          message: e.toString(),
        ),
      );
    }
  }
  // Future<void> getSocialMediaList() async {
  //   try {
  //     emit(const SocialMediaState.loading());

  //     if (_socialMediaList.isEmpty) {
  //       final result = await _repository.socialMediaList();
  //       _socialMediaList = result;
  //       emit(SocialMediaState.loaded(socialMediaList: _socialMediaList));
  //     } else {
  //       emit(SocialMediaState.loaded(socialMediaList: _socialMediaList));
  //     }
  //   } on RestClientException catch (e) {
  //     emit(
  //       SocialMediaState.error(
  //         message: e.message,
  //       ),
  //     );
  //   } catch (e) {
  //     emit(
  //       SocialMediaState.error(
  //         message: e.toString(),
  //       ),
  //     );
  //   }
  // }
}

@freezed
class SocialMediaState with _$SocialMediaState {
  const factory SocialMediaState.initial() = _InitialState;

  const factory SocialMediaState.loading() = _LoadingState;

  const factory SocialMediaState.loaded({
    required List<SocialMediaDTO> socialMediaList,
  }) = _LoadedState;

  const factory SocialMediaState.error({
    required String message,
  }) = _ErrorState;
}
