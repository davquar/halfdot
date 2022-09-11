class WebsitesResponse {
  List<Website> websites = [];

  WebsitesResponse(this.websites);

  WebsitesResponse.fromJSON(List<dynamic> json) {
    for (var website in json) {
      websites.add(Website.fromJSON(website));
    }
  }
}

class Website {
  final int id;
  final String uuid;
  final int userId;
  final String name;
  final String domain;
  final DateTime createdAt;
  final String? shareId;

  Website(this.id, this.uuid, this.userId, this.name, this.domain, this.createdAt, this.shareId);

  Website.fromJSON(Map<String, dynamic> json)
      : id = json["website_id"],
        uuid = json["website_uuid"],
        userId = json["user_id"],
        name = json["name"],
        domain = json["domain"],
        createdAt = DateTime.parse(json["created_at"]),
        shareId = json["share_id"];
}
