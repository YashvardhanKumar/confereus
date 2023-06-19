// // GENERATED CODE - DO NOT MODIFY BY HAND
//
// part of 'user_model.dart';
//
// // **************************************************************************
// // RealmObjectGenerator
// // **************************************************************************
//
// class Users extends _Users with RealmEntity, RealmObjectBase, RealmObject {
//   Users(
//     ObjectId id,
//     String email,
//     String name,
//     DateTime dob,
//     bool emailVerified,
//     String provider, {
//     String? password,
//     String? profileImageURL,
//     Iterable<WorkExperience> workExperience = const [],
//     Iterable<Education> education = const [],
//     Iterable<Skills> skills = const [],
//   }) {
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, 'email', email);
//     RealmObjectBase.set(this, 'name', name);
//     RealmObjectBase.set(this, 'password', password);
//     RealmObjectBase.set(this, 'dob', dob);
//     RealmObjectBase.set(this, 'emailVerified', emailVerified);
//     RealmObjectBase.set(this, 'profileImageURL', profileImageURL);
//     RealmObjectBase.set(this, 'provider', provider);
//     RealmObjectBase.set<RealmList<WorkExperience>>(
//         this, 'workExperience', RealmList<WorkExperience>(workExperience));
//     RealmObjectBase.set<RealmList<Education>>(
//         this, 'education', RealmList<Education>(education));
//     RealmObjectBase.set<RealmList<Skills>>(
//         this, 'skills', RealmList<Skills>(skills));
//   }
//
//   Users._();
//
//   @override
//   ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
//   @override
//   set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);
//
//   @override
//   String get email => RealmObjectBase.get<String>(this, 'email') as String;
//   @override
//   set email(String value) => RealmObjectBase.set(this, 'email', value);
//
//   @override
//   String get name => RealmObjectBase.get<String>(this, 'name') as String;
//   @override
//   set name(String value) => RealmObjectBase.set(this, 'name', value);
//
//   @override
//   String? get password =>
//       RealmObjectBase.get<String>(this, 'password') as String?;
//   @override
//   set password(String? value) => RealmObjectBase.set(this, 'password', value);
//
//   @override
//   DateTime get dob => RealmObjectBase.get<DateTime>(this, 'dob') as DateTime;
//   @override
//   set dob(DateTime value) => RealmObjectBase.set(this, 'dob', value);
//
//   @override
//   bool get emailVerified =>
//       RealmObjectBase.get<bool>(this, 'emailVerified') as bool;
//   @override
//   set emailVerified(bool value) =>
//       RealmObjectBase.set(this, 'emailVerified', value);
//
//   @override
//   String? get profileImageURL =>
//       RealmObjectBase.get<String>(this, 'profileImageURL') as String?;
//   @override
//   set profileImageURL(String? value) =>
//       RealmObjectBase.set(this, 'profileImageURL', value);
//
//   @override
//   String get provider =>
//       RealmObjectBase.get<String>(this, 'provider') as String;
//   @override
//   set provider(String value) => RealmObjectBase.set(this, 'provider', value);
//
//   @override
//   RealmList<WorkExperience> get workExperience =>
//       RealmObjectBase.get<WorkExperience>(this, 'workExperience')
//           as RealmList<WorkExperience>;
//   @override
//   set workExperience(covariant RealmList<WorkExperience> value) =>
//       throw RealmUnsupportedSetError();
//
//   @override
//   RealmList<Education> get education =>
//       RealmObjectBase.get<Education>(this, 'education') as RealmList<Education>;
//   @override
//   set education(covariant RealmList<Education> value) =>
//       throw RealmUnsupportedSetError();
//
//   @override
//   RealmList<Skills> get skills =>
//       RealmObjectBase.get<Skills>(this, 'skills') as RealmList<Skills>;
//   @override
//   set skills(covariant RealmList<Skills> value) =>
//       throw RealmUnsupportedSetError();
//
//   @override
//   Stream<RealmObjectChanges<Users>> get changes =>
//       RealmObjectBase.getChanges<Users>(this);
//
//   @override
//   Users freeze() => RealmObjectBase.freezeObject<Users>(this);
//
//   static SchemaObject get schema => _schema ??= _initSchema();
//   static SchemaObject? _schema;
//   static SchemaObject _initSchema() {
//     RealmObjectBase.registerFactory(Users._);
//     return const SchemaObject(ObjectType.realmObject, Users, 'Users', [
//       SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
//       SchemaProperty('email', RealmPropertyType.string),
//       SchemaProperty('name', RealmPropertyType.string),
//       SchemaProperty('password', RealmPropertyType.string, optional: true),
//       SchemaProperty('dob', RealmPropertyType.timestamp),
//       SchemaProperty('emailVerified', RealmPropertyType.bool),
//       SchemaProperty('profileImageURL', RealmPropertyType.string,
//           optional: true),
//       SchemaProperty('provider', RealmPropertyType.string),
//       SchemaProperty('workExperience', RealmPropertyType.object,
//           linkTarget: 'WorkExperience',
//           collectionType: RealmCollectionType.list),
//       SchemaProperty('education', RealmPropertyType.object,
//           linkTarget: 'Education', collectionType: RealmCollectionType.list),
//       SchemaProperty('skills', RealmPropertyType.object,
//           linkTarget: 'Skills', collectionType: RealmCollectionType.list),
//     ]);
//   }
// }
//
// class WorkExperience extends _WorkExperience
//     with RealmEntity, RealmObjectBase, RealmObject {
//   WorkExperience(
//     ObjectId id,
//     String position,
//     String company,
//     String jobType,
//     DateTime start,
//     DateTime end, {
//     String? location,
//   }) {
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, 'position', position);
//     RealmObjectBase.set(this, 'company', company);
//     RealmObjectBase.set(this, 'jobType', jobType);
//     RealmObjectBase.set(this, 'location', location);
//     RealmObjectBase.set(this, 'start', start);
//     RealmObjectBase.set(this, 'end', end);
//   }
//
//   WorkExperience._();
//
//   @override
//   ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
//   @override
//   set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);
//
//   @override
//   String get position =>
//       RealmObjectBase.get<String>(this, 'position') as String;
//   @override
//   set position(String value) => RealmObjectBase.set(this, 'position', value);
//
//   @override
//   String get company => RealmObjectBase.get<String>(this, 'company') as String;
//   @override
//   set company(String value) => RealmObjectBase.set(this, 'company', value);
//
//   @override
//   String get jobType => RealmObjectBase.get<String>(this, 'jobType') as String;
//   @override
//   set jobType(String value) => RealmObjectBase.set(this, 'jobType', value);
//
//   @override
//   String? get location =>
//       RealmObjectBase.get<String>(this, 'location') as String?;
//   @override
//   set location(String? value) => RealmObjectBase.set(this, 'location', value);
//
//   @override
//   DateTime get start =>
//       RealmObjectBase.get<DateTime>(this, 'start') as DateTime;
//   @override
//   set start(DateTime value) => RealmObjectBase.set(this, 'start', value);
//
//   @override
//   DateTime get end => RealmObjectBase.get<DateTime>(this, 'end') as DateTime;
//   @override
//   set end(DateTime value) => RealmObjectBase.set(this, 'end', value);
//
//   @override
//   RealmResults<Users> get linkedUser =>
//       RealmObjectBase.get<Users>(this, 'linkedUser') as RealmResults<Users>;
//   @override
//   set linkedUser(covariant RealmResults<Users> value) =>
//       throw RealmUnsupportedSetError();
//
//   @override
//   Stream<RealmObjectChanges<WorkExperience>> get changes =>
//       RealmObjectBase.getChanges<WorkExperience>(this);
//
//   @override
//   WorkExperience freeze() => RealmObjectBase.freezeObject<WorkExperience>(this);
//
//   static SchemaObject get schema => _schema ??= _initSchema();
//   static SchemaObject? _schema;
//   static SchemaObject _initSchema() {
//     RealmObjectBase.registerFactory(WorkExperience._);
//     return const SchemaObject(
//         ObjectType.realmObject, WorkExperience, 'WorkExperience', [
//       SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
//       SchemaProperty('position', RealmPropertyType.string),
//       SchemaProperty('company', RealmPropertyType.string),
//       SchemaProperty('jobType', RealmPropertyType.string),
//       SchemaProperty('location', RealmPropertyType.string, optional: true),
//       SchemaProperty('start', RealmPropertyType.timestamp),
//       SchemaProperty('end', RealmPropertyType.timestamp),
//       SchemaProperty('linkedUser', RealmPropertyType.linkingObjects,
//           linkOriginProperty: 'workExperience',
//           collectionType: RealmCollectionType.list,
//           linkTarget: 'Users'),
//     ]);
//   }
// }
//
// class Education extends _Education
//     with RealmEntity, RealmObjectBase, RealmObject {
//   Education(
//     ObjectId id,
//     String institution,
//     String degree,
//     String field,
//     DateTime start,
//     DateTime end, {
//     String? location,
//   }) {
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, 'institution', institution);
//     RealmObjectBase.set(this, 'degree', degree);
//     RealmObjectBase.set(this, 'field', field);
//     RealmObjectBase.set(this, 'location', location);
//     RealmObjectBase.set(this, 'start', start);
//     RealmObjectBase.set(this, 'end', end);
//   }
//
//   Education._();
//
//   @override
//   ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
//   @override
//   set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);
//
//   @override
//   String get institution =>
//       RealmObjectBase.get<String>(this, 'institution') as String;
//   @override
//   set institution(String value) =>
//       RealmObjectBase.set(this, 'institution', value);
//
//   @override
//   String get degree => RealmObjectBase.get<String>(this, 'degree') as String;
//   @override
//   set degree(String value) => RealmObjectBase.set(this, 'degree', value);
//
//   @override
//   String get field => RealmObjectBase.get<String>(this, 'field') as String;
//   @override
//   set field(String value) => RealmObjectBase.set(this, 'field', value);
//
//   @override
//   String? get location =>
//       RealmObjectBase.get<String>(this, 'location') as String?;
//   @override
//   set location(String? value) => RealmObjectBase.set(this, 'location', value);
//
//   @override
//   DateTime get start =>
//       RealmObjectBase.get<DateTime>(this, 'start') as DateTime;
//   @override
//   set start(DateTime value) => RealmObjectBase.set(this, 'start', value);
//
//   @override
//   DateTime get end => RealmObjectBase.get<DateTime>(this, 'end') as DateTime;
//   @override
//   set end(DateTime value) => RealmObjectBase.set(this, 'end', value);
//
//   @override
//   RealmResults<Users> get linkedUser =>
//       RealmObjectBase.get<Users>(this, 'linkedUser') as RealmResults<Users>;
//   @override
//   set linkedUser(covariant RealmResults<Users> value) =>
//       throw RealmUnsupportedSetError();
//
//   @override
//   Stream<RealmObjectChanges<Education>> get changes =>
//       RealmObjectBase.getChanges<Education>(this);
//
//   @override
//   Education freeze() => RealmObjectBase.freezeObject<Education>(this);
//
//   static SchemaObject get schema => _schema ??= _initSchema();
//   static SchemaObject? _schema;
//   static SchemaObject _initSchema() {
//     RealmObjectBase.registerFactory(Education._);
//     return const SchemaObject(ObjectType.realmObject, Education, 'Education', [
//       SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
//       SchemaProperty('institution', RealmPropertyType.string),
//       SchemaProperty('degree', RealmPropertyType.string),
//       SchemaProperty('field', RealmPropertyType.string),
//       SchemaProperty('location', RealmPropertyType.string, optional: true),
//       SchemaProperty('start', RealmPropertyType.timestamp),
//       SchemaProperty('end', RealmPropertyType.timestamp),
//       SchemaProperty('linkedUser', RealmPropertyType.linkingObjects,
//           linkOriginProperty: 'education',
//           collectionType: RealmCollectionType.list,
//           linkTarget: 'Users'),
//     ]);
//   }
// }
//
// class Skills extends _Skills with RealmEntity, RealmObjectBase, RealmObject {
//   Skills(
//     ObjectId id,
//     String skill,
//     String expertise,
//   ) {
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, 'skill', skill);
//     RealmObjectBase.set(this, 'expertise', expertise);
//   }
//
//   Skills._();
//
//   @override
//   ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
//   @override
//   set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);
//
//   @override
//   String get skill => RealmObjectBase.get<String>(this, 'skill') as String;
//   @override
//   set skill(String value) => RealmObjectBase.set(this, 'skill', value);
//
//   @override
//   String get expertise =>
//       RealmObjectBase.get<String>(this, 'expertise') as String;
//   @override
//   set expertise(String value) => RealmObjectBase.set(this, 'expertise', value);
//
//   @override
//   RealmResults<Users> get linkedUser =>
//       RealmObjectBase.get<Users>(this, 'linkedUser') as RealmResults<Users>;
//   @override
//   set linkedUser(covariant RealmResults<Users> value) =>
//       throw RealmUnsupportedSetError();
//
//   @override
//   Stream<RealmObjectChanges<Skills>> get changes =>
//       RealmObjectBase.getChanges<Skills>(this);
//
//   @override
//   Skills freeze() => RealmObjectBase.freezeObject<Skills>(this);
//
//   static SchemaObject get schema => _schema ??= _initSchema();
//   static SchemaObject? _schema;
//   static SchemaObject _initSchema() {
//     RealmObjectBase.registerFactory(Skills._);
//     return const SchemaObject(ObjectType.realmObject, Skills, 'Skills', [
//       SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
//       SchemaProperty('skill', RealmPropertyType.string),
//       SchemaProperty('expertise', RealmPropertyType.string),
//       SchemaProperty('linkedUser', RealmPropertyType.linkingObjects,
//           linkOriginProperty: 'skills',
//           collectionType: RealmCollectionType.list,
//           linkTarget: 'Users'),
//     ]);
//   }
// }
