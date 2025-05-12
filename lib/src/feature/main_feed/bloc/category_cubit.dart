import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/feature/main_feed/data/main_repository.dart';
import 'package:lombard/src/feature/main_feed/model/category_dto.dart';

part 'category_cubit.freezed.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit({
    required IMainRepository repository,
  })  : _repository = repository,
        super(const CategoryState.initial());
  final IMainRepository _repository;

  Future<void> getCategory() async {
    try {
      emit(const CategoryState.loading());

      final result = await _repository.categories();

      emit(CategoryState.loaded(bannerList: result));
    } on RestClientException catch (e) {
      emit(
        CategoryState.error(
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        CategoryState.error(
          message: e.toString(),
        ),
      );
    }
  }
}

@freezed
class CategoryState with _$CategoryState {
  const factory CategoryState.initial() = _InitialState;

  const factory CategoryState.loading() = _LoadingState;

  const factory CategoryState.loaded({
    required List<CategoryDTO> bannerList,
  }) = _LoadedState;

  const factory CategoryState.error({
    required String message,
  }) = _ErrorState;
}
