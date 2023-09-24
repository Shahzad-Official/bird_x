class AllChatsModel {
  bool? success;
  String? message;
  List<ChatData>? data;

  AllChatsModel({this.success, this.message, this.data});

  AllChatsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ChatData>[];
      json['data'].forEach((v) {
        data!.add(new ChatData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChatData {
  String? sId;
  String? roomId;
  String? senderId;
  String? receiverId;
  String? messageType;
  String? message;
  String? createdOn;

  ChatData({this.sId, this.roomId, this.senderId, this.receiverId, this.messageType, this.message, this.createdOn});

  ChatData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    roomId = json['roomId'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    messageType = json['messageType'];
    message = json['message'];
    createdOn = json['createdOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['roomId'] = this.roomId;
    data['senderId'] = this.senderId;
    data['receiverId'] = this.receiverId;
    data['messageType'] = this.messageType;
    data['message'] = this.message;
    data['createdOn'] = this.createdOn;
    return data;
  }
}
