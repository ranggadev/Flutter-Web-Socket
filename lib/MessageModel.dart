class MessageModel {
  String room;
  String message;
  String from;
  String to;
  String createdAt;

  MessageModel({
    this.room,
    this.message,
    this.from,
    this.to,
    this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    room: json["room"] == null ? null : json["room"],
    message: json["message"] == null ? null : json["message"],
    from: json["from"] == null ? null : json["from"],
    to: json["to"] == null ? null : json["to"],
    createdAt: json["created_at"] == null ? null : json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "room": room == null ? null : room,
    "message": message == null ? null : message,
    "from": from == null ? null : from,
    "to": to == null ? null : to,
    "created_at": createdAt == null ? null : createdAt,
  };
}