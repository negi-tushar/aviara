import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final Address address;
  final String phone;
  final String website;
  final Company company;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.phone,
    required this.website,
    required this.company,
  });

  @override
  List<Object?> get props => [id, name, email, address, phone, website, company];
}

class Address extends Equatable {
  final String street;
  final String suite;
  final String city;
  final String zipcode;

  const Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
  });

  String get fullAddress => '$street, $suite, $city - $zipcode';

  @override
  List<Object?> get props => [street, suite, city, zipcode];
}

class Company extends Equatable {
  final String name;
  final String catchPhrase;
  final String bs;

  const Company({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  @override
  List<Object?> get props => [name, catchPhrase, bs];
}
