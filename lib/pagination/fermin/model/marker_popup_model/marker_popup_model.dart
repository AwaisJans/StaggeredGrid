


class markerPopupModel {      //// NewsModel --> FerminModel
  List<markerPopupModel>? popup;

  markerPopupModel({this.popup});

  markerPopupModel.fromJson(Map<String, dynamic> json) {
    if (json["singleItem"] is List) {
      popup = (json["singleItem"] == null
          ? null
          : (json["singleItem"] as List).map((e) => markerPopup.fromJson(e)).toList())
          ?.cast<markerPopupModel>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (popup != null) {
      _data["singleItem"] = popup?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class markerPopup {
  String? bezeichnung;
  num? id;
  String? ort;
  String? plz;
  String? strasse;
  String? urlDetails;

  markerPopup({this.bezeichnung,
    this.id,
    this.ort,
    this.plz,
    this.strasse,
    this.urlDetails});

  markerPopup.fromJson(Map<String, dynamic> json) {
    if (json["bezeichnung"] is String) {
      bezeichnung = json["bezeichnung"];
    }
    if (json["ort"] is String) {
      ort = json["ort"];
    }
    if (json["plz"] is String) {
      plz = json["plz"];
    }
    if (json["strasse"] is String) {
      strasse = json["strasse"];
    }
    if (json["urlDetails"] is String) {
      urlDetails = json["urlDetails"];
      if (json["id"] is num) {
        id = json["id"];
      }
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> _data = <String, dynamic>{};

      _data["bezeichnung"] = bezeichnung;
      _data["ort"] = ort;
      _data["plz"] = plz;
      _data["strasse"] = strasse;
      _data["id"] = id;
      _data["urlDetails"] = urlDetails;
      return _data;
    }
  }


}
