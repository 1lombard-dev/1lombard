import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/feature/main_feed/data/main_repository.dart';
import 'package:lombard/src/feature/main_feed/model/main_page_dto.dart';

part 'banner_cubit.freezed.dart';

class BannerCubit extends Cubit<BannerState> {
  BannerCubit({
    required IMainRepository repository,
  })  : _repository = repository,
        super(const BannerState.initial());
  final IMainRepository _repository;

  Future<void> getMainPageBanner() async {
    try {
      emit(const BannerState.loading());

      final result = await _repository.mainPageBanner();

      emit(BannerState.loaded(bannerList: result));
    } on RestClientException catch (e) {
      emit(
        BannerState.error(
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        BannerState.error(
          message: e.toString(),
        ),
      );
    }
  }
}

@freezed
class BannerState with _$BannerState {
  const factory BannerState.initial() = _InitialState;

  const factory BannerState.loading() = _LoadingState;

  const factory BannerState.loaded({
    required List<BannerDTO> bannerList,
  }) = _LoadedState;

  const factory BannerState.error({
    required String message,
  }) = _ErrorState;
}
