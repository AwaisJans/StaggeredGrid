/// items : [{"bezeichnung":"Allianz Generalrestrerung Jochen Brendele","id":483,"lat":"48.39503446981762","lng":"8.699648380279541","urlPopUp":"https://www.empfingen.de/app-v3-nativ?action=getFirmaPopUp&singleItemId=483&cHash=3a5b8db51c2e31610e003cef4ccd1058","urlDetails":"https://www.empfingen.de/app-v3-nativ?action=getFirmaDetails&singleItemId=483&cHash=3e279aeb1453813bd5ba76b6f23c6818"},{"bezeichnung":"Empfinger Getränkemarkt","id":489,"lat":"48.39729713260604","lng":"8.70231342317311","urlPopUp":"https://www.empfingen.de/app-v3-nativ?action=getFirmaPopUp&singleItemId=489&cHash=6845102aa506a1b1a471fc74c1bfb5ad","urlDetails":"https://www.empfingen.de/app-v3-nativ?action=getFirmaDetails&singleItemId=489&cHash=df5d652934f392199372620825d37dac"}]
/// status : "ok"


import 'fermin_map_items.dart';

class FerminMapModel {      //// NewsModel --> FerminModel
  List<FerminMapModel>? fermin;

  FerminMapModel({this.fermin});

  FerminMapModel.fromJson(Map<String, dynamic> json) {
    if (json["items"] is List) {
      fermin = (json["items"] == null
          ? null
          : (json["items"] as List).map((e) => FerminMap.fromJson(e)).toList())
          ?.cast<FerminMapModel>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (fermin != null) {
      _data["items"] = fermin?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}
/*
beschreibung,
beschreibung2,
beschreibung3,
bezeichnung,
bild,
email,
extra1,
extra2,
extra3,
extra4,
extra5,
id,
fax,
homepage,
kategorien,
lat,
lng,
mobil,
ort,
plz,
strasse,
telefon,
telefon2,
urlDetails
*/

///// News -> Fermin
class FerminMap {
  String? bezeichnung;
  num? id;
  String? lat;
  String? lng;
  String? urlPopUp;
  String? urlDetails;

  FerminMap({this.bezeichnung,
    this.id,
    this.lat,
    this.lng,
    this.urlPopUp,
    this.urlDetails});

  FerminMap.fromJson(Map<String, dynamic> json) {
    if (json["bezeichnung"] is String) {
      bezeichnung = json["bezeichnung"];
    }
    if (json["lat"] is String) {
      lat = json["lat"];
    }
    if (json["lng"] is String) {
      lng = json["lng"];
    }
    if (json["urlPopUp"] is String) {
      urlPopUp = json["urlPopUp"];
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
      _data["lat"] = lat;
      _data["lng"] = lng;
      _data["urlPopUp"] = urlPopUp;
      _data["id"] = id;
      _data["urlDetails"] = urlDetails;
      return _data;
    }
  }


}
