import '../news_items.dart';

class NewsModel {
  List<NewsModel>? news;

  NewsModel({this.news});

  NewsModel.fromJson(Map<String, dynamic> json) {
    if (json["items"] is List) {
      news = (json["items"] == null
              ? null
              : (json["items"] as List).map((e) => News.fromJson(e)).toList())
          ?.cast<NewsModel>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (news != null) {
      _data["items"] = news?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class News {
  String? autor;
  String? bezeichnung;
  String? content;
  int? datum;
  int? id;
  String? teaserbild;
  String? teasertext;
  bool? topartikel;
  List<kategorien>? kategoriens;

  News(
      {this.autor,
      this.bezeichnung,
      this.content,
      this.datum,
      this.id,
      this.teaserbild,
      this.teasertext,
      this.topartikel,
      this.kategoriens});

  News.fromJson(Map<String, dynamic> json) {
    if (json["autor"] is String) {
      autor = json["autor"];
    }
    if (json["bezeichnung"] is String) {
      bezeichnung = json["bezeichnung"];
    }
    if (json["content"] is String) {
      content = json["content"];
    }
    if (json["datum"] is int) {
      datum = json["datum"];
    }
    if (json["teaserbild"] is String) {
      teaserbild = json["teaserbild"];
    }
    if (json["teasertext"] is String) {
      teasertext = json["teasertext"];
    }
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["topartikel"] is bool) {
      topartikel = json["topartikel"];
    }

    if (json["kategorien"] is List) {
      kategoriens = json["kategorien"] ?? [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};

    _data["autor"] = autor;
    _data["bezeichnung"] = bezeichnung;
    _data["content"] = content;
    _data["datum"] = datum;
    _data["teaserbild"] = teaserbild;
    _data["teasertext"] = teasertext;
    _data["id"] = id;
    _data["topartikel"] = topartikel;
    if (kategorien != null) {
      _data["kategorien"] = kategorien;
    }
    return _data;
  }
}
