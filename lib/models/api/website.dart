import 'package:halfdot/models/api/common.dart';

class WebsitesResponse implements ApiModel {
  WebsitesResponse(this.websites);
  WebsitesResponse.fromJson(Map<String, dynamic> json) {
    for (final dynamic website in json['data']) {
      websites.add(Website.fromJson(website));
    }
  }
  List<Website> websites = <Website>[];
}

class Website {
  Website(
    this.id,
    this.userId,
    this.name,
    this.domain,
    this.createdAt,
    this.shareId,
  );

  Website.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['userId'],
        name = json['name'],
        domain = json['domain'],
        createdAt = DateTime.parse(json['createdAt']),
        shareId = json['shareId'];

  final String id;
  final String userId;
  final String name;
  final String domain;
  final DateTime createdAt;
  final String? shareId;
}
