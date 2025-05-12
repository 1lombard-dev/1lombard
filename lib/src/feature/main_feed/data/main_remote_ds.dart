import 'package:flutter/foundation.dart';
import 'package:lombard/src/core/rest_client/models/basic_response.dart';
import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/core/utils/talker_logger_util.dart';
import 'package:lombard/src/feature/main_feed/model/category_dto.dart';
import 'package:lombard/src/feature/main_feed/model/main_page_dto.dart';
import 'package:lombard/src/feature/main_feed/model/question_dto.dart';
import 'package:lombard/src/feature/main_feed/model/quiz_dto.dart';

abstract interface class IMainRemoteDS {
  Future<List<BannerDTO>> mainPageBanner();

  Future<List<CategoryDTO>> categories();

  ///
  /// quiz api
  ///
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

class MainRemoteDSImpl implements IMainRemoteDS {
  const MainRemoteDSImpl({
    required this.restClient,
  });
  final IRestClient restClient;

  @override
  Future<List<BannerDTO>> mainPageBanner() async {
    try {
      final Map<String, dynamic> response = await restClient.get(
        '/list/app-functions',
        queryParams: {},
      );

      if (response['data'] == null) {
        throw Exception();
      }
      final list = await compute<List<dynamic>, List<BannerDTO>>(
        (list) => list
            .map(
              (e) => BannerDTO.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        response['data'] as List,
      );
      return list;
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#getMainPageBanner - $e', e, st);
      rethrow;
    }
  }

  @override
  Future<List<CategoryDTO>> categories() async {
    try {
      final Map<String, dynamic> response = await restClient.get(
        '/list/categories',
        queryParams: {},
      );

      if (response['data'] == null) {
        throw Exception();
      }
      final list = await compute<List<dynamic>, List<CategoryDTO>>(
        (list) => list
            .map(
              (e) => CategoryDTO.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        response['data'] as List,
      );
      return list;
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#getCategories - $e', e, st);
      rethrow;
    }
  }

  ///
  /// quiz api
  ///
  @override
  Future<List<QuestionDTO>> getQuestionList({required int testId}) async {
    try {
      final Map<String, dynamic> response = await restClient.get(
        '/test/$testId',
        queryParams: {},
      );

      if (response['data'] == null) {
        throw Exception();
      }
      final list = await compute<List<dynamic>, List<QuestionDTO>>(
        (list) => list
            .map(
              (e) => QuestionDTO.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        response['data'] as List,
      );
      return list;
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#getQuestionList - $e', e, st);
      rethrow;
    }
  }

  @override
  Future<QuizDTO> startQuiz({required int subjectId, int? sectionId}) async {
    try {
      final Map<String, dynamic> response = await restClient.post(
        '/test/start',
        body: {
          'subject_id': subjectId,
          'section_id': sectionId,
        },
      );

      return QuizDTO.fromJson(response);
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#login - $e', e, st);
      rethrow;
    }
  }

  @override
  Future<BasicResponse> errorComment({required int questionId, required String comment}) async {
    try {
      final Map<String, dynamic> response = await restClient.post(
        '/test/report-error',
        body: {
          'question_id': questionId,
          'comment': comment,
        },
      );

      return BasicResponse.fromJson(response);
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#errorComment - $e', e, st);
      rethrow;
    }
  }

  @override
  Future<BasicResponse> answerUpload({required int testId, required int questionId, required int answerId}) async {
    try {
      final Map<String, dynamic> response = await restClient.post(
        '/test/$testId/answer',
        body: {
          'question_id': questionId,
          'answer_id': answerId,
        },
      );

      return BasicResponse.fromJson(response);
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#answerUpload - $e', e, st);
      rethrow;
    }
  }

  @override
  Future<QuizResultDTO> finishTest({required int testId}) async {
    try {
      final Map<String, dynamic> response = await restClient.post(
        '/test/$testId/finish',
        body: {},
      );

      return QuizResultDTO.fromJson(response);
    } catch (e, st) {
      TalkerLoggerUtil.talker.error('#finishTest - $e', e, st);
      rethrow;
    }
  }
}
