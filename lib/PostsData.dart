// To parse this JSON data, do
//
//     final postsData = postsDataFromMap(jsonString);

import 'dart:convert';

class PostsData {
  PostsData({
    this.repository,
  });

  final Repository repository;

  factory PostsData.fromJson(String str) => PostsData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PostsData.fromMap(Map<String, dynamic> json) => PostsData(
        repository: json["repository"] == null
            ? null
            : Repository.fromMap(json["repository"]),
      );

  Map<String, dynamic> toMap() => {
        "repository": repository == null ? null : repository.toMap(),
      };
}

class Repository {
  Repository({
    this.issues,
  });

  final Issues issues;

  factory Repository.fromJson(String str) =>
      Repository.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Repository.fromMap(Map<String, dynamic> json) => Repository(
        issues: json["issues"] == null ? null : Issues.fromMap(json["issues"]),
      );

  Map<String, dynamic> toMap() => {
        "issues": issues == null ? null : issues.toMap(),
      };
}

class Issues {
  Issues({
    this.edges,
  });

  final List<Edge> edges;

  factory Issues.fromJson(String str) => Issues.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Issues.fromMap(Map<String, dynamic> json) => Issues(
        edges: json["edges"] == null
            ? null
            : List<Edge>.from(json["edges"].map((x) => Edge.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "edges": edges == null
            ? null
            : List<dynamic>.from(edges.map((x) => x.toMap())),
      };
}

class Edge {
  Edge({
    this.node,
  });

  final Node node;

  factory Edge.fromJson(String str) => Edge.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Edge.fromMap(Map<String, dynamic> json) => Edge(
        node: json["node"] == null ? null : Node.fromMap(json["node"]),
      );

  Map<String, dynamic> toMap() => {
        "node": node == null ? null : node.toMap(),
      };
}

class Node {
  Node({
    this.id,
    this.author,
    this.title,
    this.state,
    this.closed,
    this.closedAt,
    this.createdViaEmail,
    this.publishedAt,
    this.url,
  });

  final String id;
  final Author author;
  final String title;
  final State state;
  final bool closed;
  final DateTime closedAt;
  final bool createdViaEmail;
  final DateTime publishedAt;
  final String url;

  factory Node.fromJson(String str) => Node.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Node.fromMap(Map<String, dynamic> json) => Node(
        id: json["id"] == null ? null : json["id"],
        author: json["author"] == null ? null : Author.fromMap(json["author"]),
        title: json["title"] == null ? null : json["title"],
        state: json["state"] == null ? null : stateValues.map[json["state"]],
        closed: json["closed"] == null ? null : json["closed"],
        closedAt:
            json["closedAt"] == null ? null : DateTime.parse(json["closedAt"]),
        createdViaEmail:
            json["createdViaEmail"] == null ? null : json["createdViaEmail"],
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        url: json["url"] == null ? null : json["url"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "author": author == null ? null : author.toMap(),
        "title": title == null ? null : title,
        "state": state == null ? null : stateValues.reverse[state],
        "closed": closed == null ? null : closed,
        "closedAt": closedAt == null ? null : closedAt.toIso8601String(),
        "createdViaEmail": createdViaEmail == null ? null : createdViaEmail,
        "publishedAt":
            publishedAt == null ? null : publishedAt.toIso8601String(),
        "url": url == null ? null : url,
      };
}

class Author {
  Author({
    this.login,
  });

  final String login;

  factory Author.fromJson(String str) => Author.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Author.fromMap(Map<String, dynamic> json) => Author(
        login: json["login"] == null ? null : json["login"],
      );

  Map<String, dynamic> toMap() => {
        "login": login == null ? null : login,
      };
}

enum State { CLOSED, OPEN }

final stateValues = EnumValues({"CLOSED": State.CLOSED, "OPEN": State.OPEN});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
