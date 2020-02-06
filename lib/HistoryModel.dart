class HistoryModel {
  List<Datum> data;

  HistoryModel({
    this.data,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) => HistoryModel(
    data: json["Data"] == null ? null : List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String room;
  String message;
  String from;
  String to;
  String createdAt;

  Datum({
    this.room,
    this.message,
    this.from,
    this.to,
    this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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