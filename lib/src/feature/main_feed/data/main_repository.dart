import 'package:lombard/src/core/rest_client/models/basic_response.dart';
import 'package:lombard/src/feature/main_feed/data/main_remote_ds.dart';
import 'package:lombard/src/feature/main_feed/model/category_dto.dart';
import 'package:lombard/src/feature/main_feed/model/main_page_dto.dart';
import 'package:lombard/src/feature/main_feed/model/question_dto.dart';
import 'package:lombard/src/feature/main_feed/model/quiz_dto.dart';

abstract interface class IMainRepository {
  Future<List<BannerDTO>> mainPageBanner();

  Future<List<CategoryDTO>> categories();

  Future<QuizDTO> startQuiz({
    required int subjectId,
    int? sectionId,
  });

  Future<List<QuestionDTO>> getQuestionList({
    required int testId,
  });

  Future<BasicResponse> errorComment({
    required int questionId,
    required String comment,
  });

  Future<BasicResponse> answerUpload({
    required int testId,
    required int questionId,
    required int answerId,
  });

  Future<QuizResultDTO> finishTest({
    required int testId,
  });
}

class MainRepositoryImpl implements IMainRepository {
  const MainRepositoryImpl({
    required IMainRemoteDS remoteDS,
  }) : _remoteDS = remoteDS;
  final IMainRemoteDS _remoteDS;

  @override
  Future<List<BannerDTO>> mainPageBanner() async {
    try {
      return await _remoteDS.mainPageBanner();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CategoryDTO>> categories() async {
    try {
      return await _remoteDS.categories();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<QuizDTO> startQuiz({required int subjectId, int? sectionId}) async {
    try {
      return await _remoteDS.startQuiz(subjectId: subjectId, sectionId: sectionId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<QuestionDTO>> getQuestionList({required int testId}) async {
    try {
      return await _remoteDS.getQuestionList(testId: testId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BasicResponse> errorComment({required int questionId, required String comment}) async {
    try {
      return await _remoteDS.errorComment(questionId: questionId, comment: comment);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BasicResponse> answerUpload({required int testId, required int questionId, required int answerId}) async {
    try {
      return await _remoteDS.answerUpload(questionId: questionId, answerId: answerId, testId: testId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<QuizResultDTO> finishTest({required int testId}) async {
    try {
      return await _remoteDS.finishTest(testId: testId);
    } catch (e) {
      rethrow;
    }
  }
}
