class MeetingModel {
  int? year;
  int? month;
  int? day;
  int? hour;
  int? minute;
  String? subject;
  String? agencyId;
  String? client;
  String? agent;
  bool? accepted;
  bool? updated = false;
  bool? canceled;
  String? clientName;


  MeetingModel({
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.subject,
    this.agencyId,
    this.client,
    this.agent,
    this.accepted,
    this.updated,
    this.canceled,
    this.clientName,
  });


  MeetingModel.fromJson(Map<String,dynamic> json) {
    year = json['year'];
    month = json['month'];
    day = json['day'];
    hour = json['hour'];
    minute = json['minute'];
    subject = json['subject'];
    agencyId = json['agencyId'];
    client = json['client'];
    agent = json['agent'];
    accepted = json['accepted'];
    updated = json['updated'];
    canceled = json['canceled'];
    clientName = json['clientName'];
  }

  Map<String,dynamic> toMap(){
    return {
      'year' : year,
      'month' : month,
      'day' : day,
      'hour' : hour,
      'minute' : minute,
      'subject' : subject,
      'agencyId' : agencyId,
      'client' : client,
      'agent' : agent,
      'accepted' : accepted,
      'updated' : updated,
      'canceled' :  canceled,
      'clientName' :  clientName,
    };
  }
}