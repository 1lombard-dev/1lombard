import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/feature/main_feed/model/main_page_dto.dart';
import 'package:lombard/src/feature/map/data/map_repository.dart';

part 'city_cubit.freezed.dart';

class CityCubit extends Cubit<CityState> {
  CityCubit({
    required IMapRepository repository,
  })  : _repository = repository,
        super(const CityState.initial());
  final IMapRepository _repository;

  Future<void> getCity() async {
    try {
      emit(const CityState.loading());

      final result = await _repository.getCity();

      emit(CityState.loaded(cityName: result));
    } on RestClientException catch (e) {
      emit(
        CityState.error(
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        CityState.error(
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> getCityDetail({required String name}) async {
    try {
      emit(const CityState.loading());

      final result = await _repository.getCityDetail(name: name);

      emit(CityState.loaded(cityName: result));
    } on RestClientException catch (e) {
      emit(
        CityState.error(
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        CityState.error(
          message: e.toString(),
        ),
      );
    }
  }
}

@freezed
class CityState with _$CityState {
  const factory CityState.initial() = _InitialState;

  const factory CityState.loading() = _LoadingState;

  const factory CityState.loaded({
    required List<LayersDTO> cityName,
  }) = _LoadedState;

  const factory CityState.error({
    required String message,
  }) = _ErrorState;
}
