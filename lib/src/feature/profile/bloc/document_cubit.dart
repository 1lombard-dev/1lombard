import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lombard/src/core/rest_client/rest_client.dart';
import 'package:lombard/src/feature/profile/data/profile_repository.dart';
import 'package:lombard/src/feature/profile/models/response/document_dto.dart';

part 'document_cubit.freezed.dart';

class DocumentCubit extends Cubit<DocumentState> {
  DocumentCubit({
    required IProfileRepository repository,
  })  : _repository = repository,
        super(const DocumentState.initial());
  final IProfileRepository _repository;

  Future<void> getDocument() async {
    try {
      emit(const DocumentState.loading());

      final result = await _repository.documents();

      emit(DocumentState.loaded(documentsDTO: result));
    } on RestClientException catch (e) {
      emit(
        DocumentState.error(
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        DocumentState.error(
          message: e.toString(),
        ),
      );
    }
  }
}

@freezed
class DocumentState with _$DocumentState {
  const factory DocumentState.initial() = _InitialState;

  const factory DocumentState.loading() = _LoadingState;

  const factory DocumentState.loaded({
    required List<DocumentDTO> documentsDTO,
  }) = _LoadedState;

  const factory DocumentState.error({
    required String message,
  }) = _ErrorState;
}
