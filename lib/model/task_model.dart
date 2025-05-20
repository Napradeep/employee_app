class TaskModel {
  final String employee;
  final String title;
  final String description;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String token;

  final String senderMobile;
  final String senderUserId;
  final String senderName;
  final String recivedId;

  TaskModel({
    required this.employee,
    required this.title,
    required this.description,
    required this.startDateTime,
    required this.endDateTime,
    required this.token,
    required this.senderMobile,
    required this.senderUserId,
    required this.senderName,
    required this.recivedId,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      employee: json['employee'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startDateTime: DateTime.parse(json['startDateTime'] as String),
      endDateTime: DateTime.parse(json['endDateTime'] as String),
      token: json['token'] as String,
      senderMobile: json['senderMobile'] as String,
      senderUserId: json['senderUserId'] as String,
      senderName: json['senderName'] as String,
      recivedId: json['recivedId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employee': employee,
      'title': title,
      'description': description,
      'startDateTime': startDateTime.toIso8601String(),
      'endDateTime': endDateTime.toIso8601String(),
      'token': token,
      'senderMobile': senderMobile,
      'senderUserId': senderUserId,
      'senderName': senderName,
      'recivedId': recivedId,
    };
  }
}
