import 'package:freezed_annotation/freezed_annotation.dart';

part 'tickets_dto.freezed.dart';
part 'tickets_dto.g.dart';

@freezed
class TicketsDTO with _$TicketsDTO {
  const factory TicketsDTO({
    int? id,
    @JsonKey(name: 'ticketnumber') String? ticketnumber,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'paylink') String? paylink,
    @JsonKey(name: 'paydays') String? paydays,
    @JsonKey(name: 'issuedate') String? issuedate,
    @JsonKey(name: 'totalrefundamount') String? totalrefundamount,
    @JsonKey(name: 'returndate') String? returndate,
    @JsonKey(name: 'totalpaidamount') String? totalpaidamount,
    @JsonKey(name: 'garantdate') String? garantdate,
    @JsonKey(name: 'manager') String? manager,
    @JsonKey(name: 'pledges') List<PledgesDTO>? pledges,

  }) = _CategoryDTO;

  factory TicketsDTO.fromJson(Map<String, dynamic> json) => _$TicketsDTOFromJson(json);
}

@freezed
class PledgesDTO with _$PledgesDTO {
  const factory PledgesDTO({
    @JsonKey(name: 'itemname') String? itemname,
    @JsonKey(name: 'itemcount') String? itemcount,
  }) = _PledgesDTO;

  factory PledgesDTO.fromJson(Map<String, dynamic> json) => _$PledgesDTOFromJson(json);
}
