import 'package:realm/realm.dart';

part 'user_model.g.dart';

@RealmModel()
class _Users {
  @PrimaryKey()
  late ObjectId id;

  late String email, password, name;
  late DateTime dob;

  late List<_WorkExperience> workExperience;
  late List<_Education> education;
  late List<_Skills> skills;
}

@RealmModel()
class _WorkExperience {
  @PrimaryKey()
  late ObjectId id;

  late String position, company, jobType;
  late String? location;
  late DateTime start, end;

  @Backlink(#workExperience)
  late Iterable<_Users> linkedUser;
}

@RealmModel()
class _Education {
  @PrimaryKey()
  late ObjectId id;

  late String institution, degree, field;
  late String? location;
  late DateTime start, end;

  @Backlink(#education)
  late Iterable<_Users> linkedUser;
}

@RealmModel()
class _Skills {
  @PrimaryKey()
  late ObjectId id;

  late String skill, expertise;

  @Backlink(#skills)
  late Iterable<_Users> linkedUser;
}