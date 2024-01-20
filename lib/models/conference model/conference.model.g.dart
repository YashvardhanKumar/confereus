// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conference.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conference _$ConferenceFromJson(Map<String, dynamic> json) => Conference(
      eventsId: (json['eventsId'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      admin_data: (json['admin_data'] as List<dynamic>?)
              ?.map((e) => Users.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      reviewer_data: (json['reviewer_data'] as List<dynamic>?)
              ?.map((e) => Users.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      creator: json['creator'] as String,
      reviewer: (json['reviewer'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      eventLogo: json['eventLogo'] as String?,
      id: json['_id'] as String,
      subject: json['subject'] as String,
      about: json['about'] as String,
      startTime: DateTime.parse(json['startTime'] as String).toLocal(),
      endTime: DateTime.parse(json['endTime'] as String).toLocal(),
      admin: (json['admin'] as List<dynamic>).map((e) => e as String).toList(),
      visibility: json['visibility'] as String?,
      location: json['location'] as String,
      registered: json['registered'] as List<dynamic>,
      events_data: (json['events_data'] as List<dynamic>?)
              ?.map((e) => Event.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ConferenceToJson(Conference instance) =>
    <String, dynamic>{
      // '_id': instance.id,
      'subject': instance.subject,
      'about': instance.about,
      'creator': instance.creator,
      'startTime': instance.startTime.toLocal().toIso8601String(),
      'endTime': instance.endTime.toLocal().toIso8601String(),
      'admin': instance.admin,
      'visibility': instance.visibility,
      'registered': instance.registered,
      'reviewer': instance.reviewer,
      'eventsId': instance.eventsId,
      'eventLogo': instance.eventLogo,
      'location': instance.location,
      'admin_data': instance.admin_data,
      'reviewer_data': instance.reviewer_data,
      'events_data': instance.events_data,
    };

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      reviewer: json['reviewer'],
      id: json['_id'] as String,
      subject: json['subject'] as String,
      presenter: json['presenter'] as List<dynamic>?,
      startTime: DateTime.parse(json['startTime'] as String).toLocal(),
      endTime: DateTime.parse(json['endTime'] as String).toLocal(),
      location: json['location'] as String,
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      // '_id': instance.id,
      'subject': instance.subject,
      'reviewer': instance.reviewer,
      'presenter': instance.presenter,
      'startTime': instance.startTime.toLocal().toIso8601String(),
      'endTime': instance.endTime.toLocal().toIso8601String(),
      'location': instance.location,
    };
