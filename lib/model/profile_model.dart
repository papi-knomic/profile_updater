import 'dart:io';

class ProfileModel {
  String firstname;
  String lastname;
  String address;
  String phone;
  String nationality;
  File image;

  ProfileModel(
      {required this.firstname,
      required this.lastname,
      required this.address,
      required this.phone,
      required this.nationality,
      required this.image});
}
