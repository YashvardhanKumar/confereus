import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'conference.model.g.dart';

@JsonSerializable()
class Conference {
  final String id;

  final String subject, about;
  final DateTime startTime, endTime;
  final dynamic admin;
  final String? visibility, abstractLink;
  final List? registered;
  final List<Event>? events;
  final String? eventLogo;
  final String? location;

  Conference({
    this.eventLogo,
    required this.id,
    required this.subject,
    required this.about,
    required this.startTime,
    required this.endTime,
    this.admin,
    this.visibility,
    this.abstractLink,
    this.location,
    this.registered,
    this.events,
  });

  factory Conference.fromJson(Map<String, dynamic> json) =>
      _$ConferenceFromJson(json);

  Map<String, dynamic> toJson() => _$ConferenceToJson(this);
}

@JsonSerializable()
class Event {
  final String id;

  final String subject;
  final List? presenter;
  final DateTime startTime;
  final DateTime endTime;
  final String location;

  Event({
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
