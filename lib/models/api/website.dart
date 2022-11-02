import 'package:umami/models/api/common.dart';

class WebsitesResponse implements ApiModel {
  WebsitesResponse(this.websites);
  WebsitesResponse.fromJson(List<dynamic> json) {
    for (final dynamic website in json) {
      websites.add(Website.fromJson(website));
    }
  }
  List<Website> websites = <Website>[];
}

class Website {
  Website(this.id, this.uuid, this.userId, this.name, this.domain, this.createdAt, this.shareId);

  Website.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        uuid = json['websiteUuid'],
        userId = json['userId'],
        name = json['name'],
        domain = json['domain'],
        createdAt = DateTime.parse(json['createdAt']),
        shareId = json['shareId'];

  final int id;
  final String uuid;
  final int userId;
  final String name;
  final String domain;
  final DateTime createdAt;
  final String? shareId;
}
