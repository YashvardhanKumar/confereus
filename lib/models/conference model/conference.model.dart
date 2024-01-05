import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

import '../user model/user_model.dart';

part 'conference.model.g.dart';

@JsonSerializable()
class Conference {
  final String id;

  final String subject, about;
  final DateTime startTime, endTime;
  final String? creator;
  final List<String> admin;
  final String? visibility;
  final List registered;
  final List<String>? reviewer;
  final List<Event> events;
  final String? eventLogo;
  final String? location;
  final List<Users>? admin_data, reviewer_data;

  Conference({
    this.admin_data,
    this.reviewer_data,
    this.creator,
    this.reviewer,
    this.eventLogo,
    required this.id,
    required this.subject,
    required this.about,
    required this.startTime,
    required this.endTime,
    required this.admin,
    this.visibility,
    this.location,
    required this.registered,
    required this.events,
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
