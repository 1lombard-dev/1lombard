import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/feature/profile/data/profile_repository.dart';
import 'package:lombard/src/feature/profile/models/response/about_us_dto.dart';

part 'about_us_cubit.freezed.dart';

class AboutUsCubit extends Cubit<AboutUsState> {
  AboutUsCubit({
    required IProfileRepository repository,
  })  : _repository = repository,
        super(const AboutUsState.initial());
  final IProfileRepository _repository;

  Future<void> getAboutUsData({
    bool hasDelay = false,
    bool hasLoading = false,
  }) async {
    try {
      if (hasLoading) {
        emit(const AboutUsState.loading());
      }

      if (hasDelay) {
        await Future.delayed(const Duration(milliseconds: 500));
      }

      final result = await _repository.aboutUsList();

      emit(AboutUsState.loaded(aboutUsDTO: result));
    } on RestClientException catch (e) {
      emit(
        AboutUsState.error(
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        AboutUsState.error(
          message: e.toString(),
        ),
      );
    }
  }
}

@freezed
class AboutUsState with _$AboutUsState {
  const factory AboutUsState.initial() = _InitialState;

  const factory AboutUsState.loading() = _LoadingState;

  const factory AboutUsState.loaded({
    required List<AboutUsDTO> aboutUsDTO,
  }) = _LoadedState;

  const factory AboutUsState.error({
    required String message,
  }) = _ErrorState;
}
