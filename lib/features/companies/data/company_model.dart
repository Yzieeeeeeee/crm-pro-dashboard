import 'package:equatable/equatable.dart';

/// Data model representing a company/user from the JSONPlaceholder API.
class CompanyModel extends Equatable {
  final int id;
  final String name;
  final String username;
  final String email;
  final AddressModel address;
  final String phone;
  final String website;
  final CompanyInfoModel company;

  const CompanyModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.address,
    required this.phone,
    required this.website,
    required this.company,
  });

  /// Returns uppercase initials from the company name (e.g. "Stripe Inc" → "SI").
  String get initials {
    final parts = company.name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  /// Utility getter to retrieve the company name easily
  String get companyName => company.name;

  /// Utility getter to retrieve the contact name easily
  String get contactName => name;

  /// Returns a single-line formatted address string.
  String get fullAddress =>
      '${address.street}, ${address.suite}, ${address.city}, ${address.zipcode}';

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
        id: json['id'] as int,
        name: json['name'] as String,
        username: json['username'] as String,
        email: json['email'] as String,
        address: AddressModel.fromJson(json['address'] as Map<String, dynamic>),
        phone: json['phone'] as String,
        website: json['website'] as String,
        company:
            CompanyInfoModel.fromJson(json['company'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'username': username,
        'email': email,
        'address': address.toJson(),
        'phone': phone,
        'website': website,
        'company': company.toJson(),
      };

  @override
  List<Object?> get props =>
      [id, name, username, email, address, phone, website, company];
}

/// Address sub-model with geo-coordinates.
class AddressModel extends Equatable {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final GeoModel geo;

  const AddressModel({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        street: json['street'] as String,
        suite: json['suite'] as String,
        city: json['city'] as String,
        zipcode: json['zipcode'] as String,
        geo: GeoModel.fromJson(json['geo'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'street': street,
        'suite': suite,
        'city': city,
        'zipcode': zipcode,
        'geo': geo.toJson(),
      };

  @override
  List<Object?> get props => [street, suite, city, zipcode, geo];
}

/// Geo-coordinate sub-model.
class GeoModel extends Equatable {
  final String lat;
  final String lng;

  const GeoModel({required this.lat, required this.lng});

  factory GeoModel.fromJson(Map<String, dynamic> json) => GeoModel(
        lat: json['lat'] as String,
        lng: json['lng'] as String,
      );

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};

  @override
  List<Object?> get props => [lat, lng];
}

/// Company information sub-model.
class CompanyInfoModel extends Equatable {
  final String name;
  final String catchPhrase;
  final String bs;

  const CompanyInfoModel({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  factory CompanyInfoModel.fromJson(Map<String, dynamic> json) =>
      CompanyInfoModel(
        name: json['name'] as String,
        catchPhrase: json['catchPhrase'] as String,
        bs: json['bs'] as String,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'catchPhrase': catchPhrase,
        'bs': bs,
      };

  @override
  List<Object?> get props => [name, catchPhrase, bs];
}
