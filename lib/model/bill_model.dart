class BillModel {
  String? agencyId;
  String? subject;
  String? budget;
  String? clientCIN;
  String? ddl;
  String? employeeId;
  bool? received;
  int? recursion;

  BillModel({
    this.agencyId,
    this.budget,
    this.clientCIN,
    this.subject,
    this.ddl,
    this.employeeId,
    this.received,
    this.recursion,
  });

  BillModel.fromJson(Map<String,dynamic> json){
    agencyId = json['agencyId'];
    budget = json['budget'];
    subject = json['subject'];
    clientCIN = json['clientCIN'];
    ddl = json['ddl'];
    employeeId = json['employeeId'];
    received = json['notified'];
    recursion = json['recursion'];
  }

  Map<String,dynamic> toMap(){
    return {
      'agencyId' : agencyId,
      'subject' : subject,
      'budget' : budget,
      'clientCIN' : clientCIN,
      'ddl' : ddl,
      'employeeId' : employeeId,
      'received' : received,
      'recursion' : recursion,
    };
  }
}