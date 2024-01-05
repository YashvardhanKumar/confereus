// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'abstract.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Abstract _$AbstractFromJson(Map<String, dynamic> json) => Abstract(
      conference: json['conference'] == null
          ? null
          : Conference.fromJson(json['conference'][0] as Map<String, dynamic>),
      event: json['event'] == null
          ? null
          : Event.fromJson(json['event'][0] as Map<String, dynamic>),
      users: (json['users'] as List<dynamic>?)
          ?.map((e) => Users.fromJson(e as Map<String, dynamic>))
          .toList(),
      eventId: json['eventId'] as String,
      paperName: json['paperName'] as String,
      paperLink: json['paperLink'] as String,
      id: json['_id'] as String,
      conferenceId: json['conferenceId'] as String,
      userId:
          (json['userId'] as List<dynamic>).map((e) => e as String).toList(),
      abstract: json['abstract'] as String,
      approved: json['approved'] == null
          ? null
          : DateTime.parse(json['approved'] as String),
      isApproved: json['isApproved'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$AbstractToJson(Abstract instance) => <String, dynamic>{
      // 'id': instance.id,
      'conferenceId': instance.conferenceId,
      'eventId': instance.eventId,
      'userId': instance.userId,
      'abstract': instance.abstract,
      'paperName': instance.paperName,
      'paperLink': instance.paperLink,
      'approved': instance.approved?.toIso8601String(),
      'isApproved': instance.isApproved,
      'createdAt': instance.createdAt.toIso8601String(),
      // 'conference': instance.conference,
      // 'event': instance.event,
      // 'users': instance.users,
    };
