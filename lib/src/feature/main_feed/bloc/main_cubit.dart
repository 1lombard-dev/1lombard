import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/feature/calculation/data/calculation_repository.dart';
import 'package:lombard/src/feature/calculation/model/gold_dto.dart';
import 'package:lombard/src/feature/main_feed/data/main_repository.dart';
import 'package:lombard/src/feature/main_feed/model/main_page_dto.dart';
import 'package:lombard/src/feature/main_feed/model/question_dto.dart';

part 'main_cubit.freezed.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit({
    required IMainRepository repository,
    required ICalculationRepository calRepository,
  })  : _repository = repository,
        _calculationRepository = calRepository,
        super(const MainState.initial());
  final IMainRepository _repository;
  final ICalculationRepository _calculationRepository;
  List<LayersDTO> bannerList = [];
  List<QuestionDTO> faq = [];
  List<GoldDTO> goldDTO = [];

  Future<void> getMainPageBanner() async {
    try {
      emit(const MainState.loading());

      final result = await _repository.mainPageBanner();

      bannerList = result;
      emit(
        MainState.loaded(bannerList: bannerList, faq: faq, goldDTO: goldDTO),
      );
    } on RestClientException catch (e) {
      emit(
        MainState.error(
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        MainState.error(
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> getFAQ() async {
    try {
      emit(const MainState.loading());

      final result = await _repository.getFAQ();
      faq = result;
      emit(MainState.loaded(faq: faq, bannerList: bannerList, goldDTO: goldDTO));
    } on RestClientException catch (e) {
      emit(
        MainState.error(
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        MainState.error(
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> getGoldList({
    bool hasDelay = true,
    bool hasLoading = true,
  }) async {
    try {
      if (hasLoading) {
        emit(const MainState.loading());
      }

      if (hasDelay) {
        await Future.delayed(const Duration(milliseconds: 500));
      }

      final result = await _calculationRepository.getGoldList();

      goldDTO = result;
      emit(MainState.loaded(goldDTO: goldDTO, bannerList: bannerList, faq: faq));
    } on RestClientException catch (e) {
      emit(MainState.error(message: e.message));
    } catch (e) {
      emit(MainState.error(message: e.toString()));
    }
  }
}

@freezed
class MainState with _$MainState {
  const factory MainState.initial() = _InitialState;

  const factory MainState.loading() = _LoadingState;

  const factory MainState.loaded({
    required List<LayersDTO> bannerList,
    required List<QuestionDTO> faq,
    required List<GoldDTO> goldDTO,
  }) = _LoadedState;

  const factory MainState.error({
    required String message,
  }) = _ErrorState;
}
