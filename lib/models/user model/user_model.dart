import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class Users {
  final String id;

  final String email, name;
  final String? password;
  final DateTime? dob;
  final bool emailVerified;
  final String? profileImageURL;
  final String provider;
  final List<String> workExperience;
  final List<String> education;
  final List<String> skills;

  final List<WorkExperience> workExperience_data;
  final List<Education> education_data;
  final List<Skills> skills_data;

  Users({
    this.workExperience = const [],
    this.education = const [],
    this.skills = const [],
    required this.id,
    required this.email,
    required this.name,
    required this.password,
    required this.dob,
    required this.emailVerified,
    this.profileImageURL,
    required this.provider,
    this.workExperience_data = const [],
    this.education_data = const [],
    this.skills_data = const [],
  });

  factory Users.fromJson(Map<String, dynamic> json) => _$UsersFromJson(json);

  Map<String, dynamic> toJson() => _$UsersToJson(this);
  @override
  bool operator == (covariant Users other) {
    return other.id == id;
  }





}

@JsonSerializable()
class WorkExperience {
  final String id;

  final String position, company, jobType;
  final String? location;
  final DateTime start;
  final DateTime? end;

  WorkExperience({
    required this.id,
    required this.position,
    required this.company,
    required this.jobType,
    this.location,
    required this.start,
    required this.end,
  });

  factory WorkExperience.fromJson(Map<String, dynamic> json) =>
      _$WorkExperienceFromJson(json);

  Map<String, dynamic> toJson() => _$WorkExperienceToJson(this);
}

@JsonSerializable()
class Education {
  final String id;

  final String institution, degree, field;
  final String? location;
  final DateTime start;
  final DateTime? end;

  Education({
    required this.id,
    required this.institution,
    required this.degree,
    required this.field,
    this.location,
    required this.start,
    required this.end,
  });

  factory Education.fromJson(Map<String, dynamic> json) =>
      _$EducationFromJson(json);

  Map<String, dynamic> toJson() => _$EducationToJson(this);
}

@JsonSerializable()
class Skills {
  final String id;

  final String skill, expertise;

  Skills({
    required this.id,
    required this.skill,
    required this.expertise,
  });

  factory Skills.fromJson(Map<String, dynamic> json) => _$SkillsFromJson(json);

  Map<String, dynamic> toJson() => _$SkillsToJson(this);
}
