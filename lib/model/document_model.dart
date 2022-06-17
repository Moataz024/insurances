
class DocumentModel {
  String? agencyId;
  String? clientCIN;
  String? employeeId;
  String? fileUrl;
  String? creationDate;
  String? name;

  DocumentModel({
    this.agencyId,
    this.clientCIN,
    this.employeeId,
    this.fileUrl,
    this.creationDate,
    this.name,

  });

  DocumentModel.fromJson(Map<String,dynamic> json){
    agencyId = json['agencyId'];
    clientCIN = json['clientCIN'];
    employeeId = json['employeeId'];
    fileUrl = json['fileUrl'];
    name = json['name'];
    creationDate = json['creationDate'].toString();
  }

  Map<String,dynamic> toMap(){
    return {
      'agencyId' : agencyId,
      'clientCIN' : clientCIN,
      'employeeId' : employeeId,
      'fileUrl' : fileUrl,
      'creationDate' : creationDate,
      'name' : name,
    };
  }
}