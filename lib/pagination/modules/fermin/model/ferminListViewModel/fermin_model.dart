


import 'fermin_items.dart';

class FerminModel {      //// NewsModel --> FerminModel
  List<FerminModel>? fermin;

  FerminModel({this.fermin});

  FerminModel.fromJson(Map<String, dynamic> json) {
    if (json["items"] is List) {
      fermin = (json["items"] == null
          ? null
          : (json["items"] as List).map((e) => Fermin.fromJson(e)).toList())
          ?.cast<FerminModel>();
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
class Fermin {
  String? beschreibung;
  String? beschreibung2;
  String? beschreibung3;
  String? bezeichnung;
  String? bild;
  String? email;
  String? extra1;
  String? extra2;
  String? extra3;
  String? extra4;
  String? extra5;
  int? id;
  String? fax;
  String? homepage;
  String? lat;
  String? lng;
  String? mobil;
  String? ort;
  String? plz;
  String? strasse;
  String? telefon;
  String? telefon2;
  String? urlDetails;

  List<kategorien>? kategoriens;

  Fermin(
      {this.beschreibung,
        this.beschreibung2,
        this.beschreibung3,
        this.bezeichnung,
        this.bild,
        this.email,
        this.extra1,
        this.extra2,
        this.extra3,
        this.extra4,
        this.extra5,
        this.id,
        this.fax,
        this.homepage,
        this.kategoriens,
        this.lat,
        this.lng,
        this.mobil,
        this.ort,
        this.plz,
        this.strasse,
        this.telefon,
        this.telefon2,
        this.urlDetails});

  Fermin.fromJson(Map<String, dynamic> json) {
    if (json["beschreibung"] is String) {
      beschreibung = json["beschreibung"];
    }
    if (json["beschreibung2"] is String) {
      beschreibung2 = json["beschreibung2"];
    }
    if (json["beschreibung3"] is String) {
      beschreibung3 = json["beschreibung3"];
    }
    if (json["bezeichnung"] is String) {
      bezeichnung = json["bezeichnung"];
    }
    if (json["bild"] is String) {
      bild = json["bild"];
    }
    if (json["email"] is String) {
      email = json["email"];
    }
    if (json["extra1"] is String) {
      extra1 = json["extra1"];
    }
    if (json["extra2"] is String) {
      extra2 = json["extra2"];
    }
    if (json["extra3"] is String) {
      extra3 = json["extra3"];
    }
    if (json["extra4"] is String) {
      extra4 = json["extra4"];
    }
    if (json["extra5"] is String) {
      extra5 = json["extra5"];
    }
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["fax"] is String) {
      fax = json["fax"];
    }
    if (json["homepage"] is String) {
      homepage = json["homepage"];
    }
    if (json["lat"] is String) {
      lat = json["lat"];
    }

 if (json["lng"] is String) {
   lng = json["lng"];
    }

 if (json["mobil"] is String) {
   mobil = json["mobil"];
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

 if (json["telefon"] is String) {
   telefon = json["telefon"];
    }

 if (json["telefon2"] is String) {
   telefon2 = json["telefon2"];
    }
 if (json["urlDetails"] is String) {
   urlDetails = json["urlDetails"];
    }
    if (json["kategorien"] is List) {
      kategoriens = json["kategorien"] ?? [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};

    _data["beschreibung"] = beschreibung;
    _data["beschreibung2"] = beschreibung2;
    _data["beschreibung3"] = beschreibung3;
    _data["bezeichnung"] = bezeichnung;
    _data["bild"] = bild;
    _data["email"] = email;
    _data["extra1"] = extra1;
    _data["extra2"] = extra2;
    _data["extra3"] = extra3;
    _data["extra4"] = extra4;
    _data["extra5"] = extra5;
    _data["id"] = id;
    _data["fax"] = fax;
    _data["homepage"] = homepage;
    _data["lat"] = lat;
    _data["lng"] = lng;
    _data["mobil"] = mobil;
    _data["ort"] = ort;
    _data["plz"] = plz;
    _data["strasse"] = strasse;
    _data["telefon"] = telefon;
    _data["telefon2"] = telefon2;
    _data["urlDetails"] = urlDetails;
    if (kategorien != null) {
      _data["kategorien"] = kategorien;
    }
    return _data;
  }
}
