class MessageModel {
  String? message;
  String? senderId;
  String? dateTime;
  String? sender;
  String? agencyId;

  MessageModel({
    this.message,
    this.senderId,
    this.dateTime,
    this.agencyId,
    this.sender,
  });


  MessageModel.fromJson(Map<String,dynamic> json) {
    message = json['message'];
    senderId = json['senderId'];
    dateTime = json['dateTime'];
    agencyId = json['agencyId'];
    sender = json['sender'];
  }

  Map<String,dynamic> toMap(){
    return {
      'message' : message,
      'senderId' : senderId,
      'dateTime' : dateTime,
      'agencyId' : agencyId,
      'sender' : sender,
    };
  }
}