import 'package:json_annotation/json_annotation.dart';

import '../conference model/conference.model.dart';
import '../user model/user_model.dart';

part 'abstract.model.g.dart';

@JsonSerializable()
class Abstract {
  final String id;

  final String conferenceId;
  final String eventId;
  final List<String> userId;
  final String abstract, paperName, paperLink;
  final DateTime? approved;
  final DateTime createdAt;
  final bool isApproved;

  final Conference? conference;
  final Event? event;
  final List<Users> users;

  Abstract({
    this.isApproved = false,
    this.conference,
    this.event,
    this.users = const [],
    required this.eventId,
    required this.paperName,
    required this.paperLink,
    required this.id,
    required this.conferenceId,
    required this.userId,
    required this.abstract,
    this.approved,
    required this.createdAt,
  });

  factory Abstract.fromJson(Map<String, dynamic> json) =>
      _$AbstractFromJson(json);

  Map<String, dynamic> toJson() => _$AbstractToJson(this);
}
