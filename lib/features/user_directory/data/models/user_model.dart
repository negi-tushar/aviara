import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart' as entity;

part 'user_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class UserModel extends entity.User {
  @HiveField(0)
  @override
  final int id;
  @HiveField(1)
  @override
  final String name;
  @HiveField(2)
  @override
  final String email;
  @HiveField(3)
  @override
  final AddressModel address;
  @HiveField(4)
  @override
  final String phone;
  @HiveField(5)
  @override
  final String website;
  @HiveField(6)
  @override
  final CompanyModel company;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.phone,
    required this.website,
    required this.company,
  }) : super(
         id: id,
         name: name,
         email: email,
         address: address,
         phone: phone,
         website: website,
         company: company,
       );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 1)
class AddressModel extends entity.Address {
  @HiveField(0)
  @override
  final String street;
  @HiveField(1)
  @override
  final String suite;
  @HiveField(2)
  @override
  final String city;
  @HiveField(3)
  @override
  final String zipcode;

  const AddressModel({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
  }) : super(street: street, suite: suite, city: city, zipcode: zipcode);

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);
  Map<String, dynamic> toJson() => _$AddressModelToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 2)
class CompanyModel extends entity.Company {
  @HiveField(0)
  @override
  final String name;
  @HiveField(1)
  @override
  final String catchPhrase;
  @HiveField(2)
  @override
  final String bs;

  const CompanyModel({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  }) : super(name: name, catchPhrase: catchPhrase, bs: bs);

  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyModelToJson(this);
}
