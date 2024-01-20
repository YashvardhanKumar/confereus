// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'abstract.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Abstract _$AbstractFromJson(Map<String, dynamic> json) => Abstract(
      isApproved: json['isApproved'] as bool? ?? false,
      conference: (json['conference'] as List<dynamic>).isEmpty
          ? null
          : Conference.fromJson(json['conference'][0] as Map<String, dynamic>),
      event: (json['event'] as List<dynamic>).isEmpty
          ? null
          : Event.fromJson(json['event'][0] as Map<String, dynamic>),
      users: (json['users'] as List<dynamic>?)
              ?.map((e) => Users.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
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
          : DateTime.parse(json['approved'] as String).toLocal(),
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
    );

Map<String, dynamic> _$AbstractToJson(Abstract instance) => <String, dynamic>{
      // '_id': instance.id,
      'conferenceId': instance.conferenceId,
      'eventId': instance.eventId,
      'userId': instance.userId,
      'abstract': instance.abstract,
      'paperName': instance.paperName,
      'paperLink': instance.paperLink,
      'approved': instance.approved?.toLocal().toIso8601String(),
      'createdAt': instance.createdAt.toLocal().toIso8601String(),
      'isApproved': instance.isApproved,
      'conference': instance.conference,
      'event': instance.event,
      'users': instance.users,
    };
