class ClientModel {
  String? fullName;
  String? email;
  String? phone;
  String? uid;
  String? cin;
  String? agencyId;
  bool? accepted;
  bool? isClient;

  ClientModel({
    this.email,
    this.phone,
    this.fullName,
    this.uid,
    this.cin,
    this.agencyId,
    this.accepted,
    this.isClient,
});

  ClientModel.fromJson(Map<String,dynamic> json){
    email = json['email'];
    fullName = json['fullName'];
    phone = json['phone'];
    uid = json['uid'];
    cin = json['cin'];
    agencyId = json['agencyId'];
    accepted = json['accepted'];
    isClient = json['isClient'];
  }

  Map<String,dynamic> toMap(){
    return {
      'fullName' : fullName,
      'email' : email,
      'phone' : phone,
      'uid' : uid,
      'cin' : cin,
      'agencyId' : agencyId,
      'accepted' : accepted,
      'isClient' : isClient,
    };
  }
}