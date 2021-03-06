import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeModel {
  String? fullName;
  String? email;
  String? phone;
  String? uid;
  String? cin;
  String? agencyId;
  String? teamId;
  bool? responsible;
  bool? confirmed;
  bool? isClient;
  bool? accepted;
  bool? updated = false;

  EmployeeModel({
    this.email,
    this.phone,
    this.fullName,
    this.uid,
    this.cin,
    this.agencyId,
    this.teamId,
    this.responsible,
    this.confirmed,
    this.isClient,
    this.accepted,
    this.updated,
  });


  EmployeeModel.fromJson(Map<String,dynamic> json) {
    email = json['email'];
    fullName = json['fullName'];
    phone = json['phone'];
    uid = json['uid'];
    cin = json['cin'];
    agencyId = json['agencyId'];
    teamId = json['teamId'];
    responsible = json['responsible'];
    confirmed = json['confirmed'];
    isClient = json['isClient'];
    accepted = json['accepted'];
    updated = json['updated'];
  }

  Map<String,dynamic> toMap(){
    return {
      'fullName' : fullName,
      'email' : email,
      'phone' : phone,
      'uid' : uid,
      'cin' : cin,
      'agencyId' : agencyId,
      'teamId' : teamId,
      'responsible' : responsible,
      'confirmed' : confirmed,
      'isClient' : isClient,
      'accepted' : accepted,
      'updated' : updated,
    };
  }
}