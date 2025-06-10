import 'package:freezed_annotation/freezed_annotation.dart';

part 'gold_dto.g.dart';
part 'gold_dto.freezed.dart';

@unfreezed
class GoldDTO with _$GoldDTO {
  factory GoldDTO({
    int? id,
    @JsonKey(name: 'sample') String? sample,
    @JsonKey(name: 'price') String? price,
  }) = _GoldDTO;

  factory GoldDTO.fromJson(Map<String, dynamic> json) => _$GoldDTOFromJson(json);
}
