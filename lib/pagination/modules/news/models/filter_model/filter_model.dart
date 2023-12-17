


/*

{
    "items": [
        {
            "bezeichnung": "Mitteilungsblatt Aktuell",
            "id": 22
        },
        {
            "bezeichnung": "Neues aus dem Rathaus",
            "id": 23
        },
        {
            "bezeichnung": "Notdienste",
            "id": 24
        },
        {
            "bezeichnung": "Öffentliche Bekanntmachung",
            "id": 25
        },
        {
            "bezeichnung": "Stellenausschreibungen",
            "id": 19
        }
    ],
    "status": "ok"
}
 */


class NewsFilterModel {
  List<NewsFilterModel>? filters;

  NewsFilterModel({this.filters});

  NewsFilterModel.fromJson(Map<String, dynamic> json) {
    if (json["items"] is List) {
      filters = (json["items"] == null
              ? null
              : (json["items"] as List).map((e) => Filters.fromJson(e)).toList())
          ?.cast<NewsFilterModel>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (filters != null) {
      _data["items"] = filters?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Filters {
  String? bezeichnung;
  int? id;

  Filters(
      {this.bezeichnung,
      this.id});

  Filters.fromJson(Map<String, dynamic> json) {

    if (json["bezeichnung"] is String) {
      bezeichnung = json["bezeichnung"];
    }
    if (json["id"] is int) {
      id = json["id"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};

    _data["bezeichnung"] = bezeichnung;
    _data["id"] = id;
    return _data;
  }
}
