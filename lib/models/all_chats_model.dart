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
        data!.add(ChatData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['roomId'] = roomId;
    data['senderId'] = senderId;
    data['receiverId'] = receiverId;
    data['messageType'] = messageType;
    data['message'] = message;
    data['createdOn'] = createdOn;
    return data;
  }
}
