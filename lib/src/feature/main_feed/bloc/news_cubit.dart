import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/feature/main_feed/data/main_repository.dart';
import 'package:lombard/src/feature/main_feed/model/main_page_dto.dart';

part 'news_cubit.freezed.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit({
    required IMainRepository repository,
  })  : _repository = repository,
        super(const NewsState.initial());
  final IMainRepository _repository;

  Future<void> getNews() async {
    try {
      emit(const NewsState.loading());

      final result = await _repository.getNews();

      emit(NewsState.loaded(news: result));
    } on RestClientException catch (e) {
      emit(
        NewsState.error(
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        NewsState.error(
          message: e.toString(),
        ),
      );
    }
  }
}

@freezed
class NewsState with _$NewsState {
  const factory NewsState.initial() = _InitialState;

  const factory NewsState.loading() = _LoadingState;

  const factory NewsState.loaded({
    required List<BannerDTO> news,
  }) = _LoadedState;

  const factory NewsState.error({
    required String message,
  }) = _ErrorState;
}
