class AgencyModel {
  String? agencyId;
  String? name;
  String? email;
  String? contactPhone;
  String? Location;
  String? creationDate;
  String? responsibleId;
  String? teamId;

  AgencyModel({
    this.agencyId,
    this.email,
    this.contactPhone,
    this.name,
    this.Location,
    this.creationDate,
    this.responsibleId,
    this.teamId,
  });

  AgencyModel.fromJson(Map<String,dynamic> json){
    agencyId = json['agencyId'];
    email = json['email'];
    name = json['name'];
    contactPhone = json['contactPhone'];
    Location = json['Location'];
    creationDate = json['creationDate'];
    responsibleId = json['responsibleId'];
    teamId = json['teamId'];
  }

  Map<String,dynamic> toMap(){
    return {
      'agencyId' : agencyId,
      'name' : name,
      'email' : email,
      'contactPhone' : contactPhone,
      'Location' : Location,
      'creationDate' : creationDate,
      'responsibleId' : responsibleId,
      'teamId' : teamId,
    };
  }
}