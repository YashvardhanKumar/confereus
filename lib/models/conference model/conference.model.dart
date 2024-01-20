import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

import '../user model/user_model.dart';

part 'conference.model.g.dart';

@JsonSerializable()
class Conference {
  final String id;

  final String subject, about;
  final String creator;
  final DateTime startTime, endTime;
  final List<String> admin;
  final String? visibility;
  final List registered;
  final List<String> reviewer;
  final List<String> eventsId;
  final String? eventLogo;
  final String location;

  final List<Users> reviewer_data;
  final List<Users> admin_data;
  final List<Event> events_data;

  Conference({
    this.eventsId = const [],
    this.admin_data = const [],
    this.reviewer_data = const [],
    required this.creator,
    this.reviewer = const [],
    this.eventLogo,
    required this.id,
    required this.subject,
    required this.about,
    required this.startTime,
    required this.endTime,
    required this.admin,
    this.visibility,
    required this.location,
    required this.registered,
    this.events_data = const [],
  });

  factory Conference.fromJson(Map<String, dynamic> json) =>
      _$ConferenceFromJson(json);

  Map<String, dynamic> toJson() => _$ConferenceToJson(this);
}

@JsonSerializable()
class Event {
  final String id;

  final String subject;
  final dynamic reviewer;
  final List? presenter;
  final DateTime startTime;
  final DateTime endTime;
  final String location;

  Event({
    this.reviewer,
    required this.id,
    required this.subject,
    required this.presenter,
    required this.startTime,
    required this.endTime,
    required this.location,
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
}
