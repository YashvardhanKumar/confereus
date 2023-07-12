// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conference.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conference _$ConferenceFromJson(Map<String, dynamic> json) => Conference(
      id: json['_id'] as String,
      subject: json['subject'] as String,
      about: json['about'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      admin: json['admin'],
      visibility: json['visibility'] as String?,
      abstractLink: json['abstractLink'] as String?,
      location: json['location'] as String?,
      eventLogo: json['eventLogo'] as String?,
      registered: json['registered'] as List<dynamic>,
      events: (json['events'] as List<dynamic>)
          .map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ConferenceToJson(Conference instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'subject': instance.subject,
      'about': instance.about,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'admin': instance.admin,
      'visibility': instance.visibility,
      'abstractLink': instance.abstractLink,
      'eventLogo': instance.eventLogo,
      'location': instance.location,
      'registered': instance.registered,
      'events': instance.events?.map((e) => e.toJson()).toList(),
    };

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      id: json['_id'] as String,
      subject: json['subject'] as String,
      presenter: json['presenter'] as List<dynamic>?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      location: json['location'] as String,
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      '_id': instance.id,
      'subject': instance.subject,
      'presenter': instance.presenter,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'location': instance.location,
    };
