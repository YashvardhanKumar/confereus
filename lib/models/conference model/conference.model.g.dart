// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conference.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conference _$ConferenceFromJson(Map<String, dynamic> json) => Conference(
      admin_data: (json['admin_data'] as List<dynamic>?)
          ?.map((e) => Users.fromJson(e as Map<String, dynamic>))
          .toList(),
      reviewer_data: (json['reviewer_data'] as List<dynamic>?)
          ?.map((e) => Users.fromJson(e as Map<String, dynamic>))
          .toList(),
      creator: json['creator'] as String?,
      reviewer:
          (json['reviewer'] as List<dynamic>).map((e) => e as String).toList(),
      eventLogo: json['eventLogo'] as String?,
      id: json['_id'] as String,
      subject: json['subject'] as String,
      about: json['about'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      admin: (json['admin'] as List<dynamic>).map((e) => e as String).toList(),
      visibility: json['visibility'] as String?,
      location: json['location'] as String?,
      registered: json['registered'] as List<dynamic>,
      events: (json['events'] as List<dynamic>)
          .map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ConferenceToJson(Conference instance) =>
    <String, dynamic>{
      // 'id': instance.id,
      'subject': instance.subject,
      'about': instance.about,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'creator': instance.creator,
      'admin': instance.admin,
      'visibility': instance.visibility,
      'registered': instance.registered,
      'reviewer': instance.reviewer,
      'events': instance.events,
      'eventLogo': instance.eventLogo,
      'location': instance.location,
      // 'admin_data': instance.admin_data,
      // 'reviewer_data': instance.reviewer_data,
    };

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      reviewer: json['reviewer'],
      id: json['_id'] as String,
      subject: json['subject'] as String,
      presenter: json['presenter'] as List<dynamic>?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      location: json['location'] as String,
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      // 'id': instance.id,
      'subject': instance.subject,
      'reviewer': instance.reviewer,
      'presenter': instance.presenter,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'location': instance.location,
    };
