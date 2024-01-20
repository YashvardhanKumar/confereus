// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Users _$UsersFromJson(Map<String, dynamic> json) => Users(
      workExperience: (json['workExperience'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      education: (json['education'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      id: json['_id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      password: json['password'] as String?,
      dob: json['dob'] == null ? null : DateTime.parse(json['dob'] as String).toLocal(),
      emailVerified: json['emailVerified'] as bool,
      profileImageURL: json['profileImageURL'] as String?,
      provider: json['provider'] as String,
      workExperience_data: (json['workExperience_data'] as List<dynamic>?)
              ?.map((e) => WorkExperience.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      education_data: (json['education_data'] as List<dynamic>?)
              ?.map((e) => Education.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      skills_data: (json['skills_data'] as List<dynamic>?)
              ?.map((e) => Skills.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UsersToJson(Users instance) => <String, dynamic>{
      // '_id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'password': instance.password,
      'dob': instance.dob?.toLocal().toIso8601String(),
      'emailVerified': instance.emailVerified,
      'profileImageURL': instance.profileImageURL,
      'provider': instance.provider,
      'workExperience': instance.workExperience,
      'education': instance.education,
      'skills': instance.skills,
      'workExperience_data': instance.workExperience_data,
      'education_data': instance.education_data,
      'skills_data': instance.skills_data,
    };

WorkExperience _$WorkExperienceFromJson(Map<String, dynamic> json) =>
    WorkExperience(
      id: json['_id'] as String,
      position: json['position'] as String,
      company: json['company'] as String,
      jobType: json['jobType'] as String,
      location: json['location'] as String?,
      start: DateTime.parse(json['start'] as String),
      end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
    );

Map<String, dynamic> _$WorkExperienceToJson(WorkExperience instance) =>
    <String, dynamic>{
      // '_id': instance.id,
      'position': instance.position,
      'company': instance.company,
      'jobType': instance.jobType,
      'location': instance.location,
      'start': instance.start.toIso8601String(),
      'end': instance.end?.toIso8601String(),
    };

Education _$EducationFromJson(Map<String, dynamic> json) => Education(
      id: json['_id'] as String,
      institution: json['institution'] as String,
      degree: json['degree'] as String,
      field: json['field'] as String,
      location: json['location'] as String?,
      start: DateTime.parse(json['start'] as String),
      end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
    );

Map<String, dynamic> _$EducationToJson(Education instance) => <String, dynamic>{
      // '_id': instance.id,
      'institution': instance.institution,
      'degree': instance.degree,
      'field': instance.field,
      'location': instance.location,
      'start': instance.start.toIso8601String(),
      'end': instance.end?.toIso8601String(),
    };

Skills _$SkillsFromJson(Map<String, dynamic> json) => Skills(
      id: json['_id'] as String,
      skill: json['skill'] as String,
      expertise: json['expertise'] as String,
    );

Map<String, dynamic> _$SkillsToJson(Skills instance) => <String, dynamic>{
      // '_id': instance.id,
      'skill': instance.skill,
      'expertise': instance.expertise,
    };
