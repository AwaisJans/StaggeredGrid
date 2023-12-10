class MyData {
  final SingleItem singleItem;
  final String status;

  MyData({required this.singleItem, required this.status});

  factory MyData.fromJson(Map<String, dynamic> json) {
    return MyData(
      singleItem: SingleItem.fromJson(json['singleItem']),
      status: json['status'],
    );
  }
}

class SingleItem {
  final String beschreibung;
  final String beschreibung2;
  final String beschreibung3;
  final String bezeichnung;
  final String bild;
  final String email;
  final String extra1;
  final String extra2;
  final String extra3;
  final String extra4;
  final String extra5;
  final int id;
  final String fax;
  final String homepage;
  final List<Kategorie> kategorien;
  final String lat;
  final String lng;
  final String mobil;
  final String ort;
  final String plz;
  final String strasse;
  final String telefon;
  final String telefon2;
  final String urlDetails;

  SingleItem({
    required this.beschreibung,
    required this.beschreibung2,
    required this.beschreibung3,
    required this.bezeichnung,
    required this.bild,
    required this.email,
    required this.extra1,
    required this.extra2,
    required this.extra3,
    required this.extra4,
    required this.extra5,
    required this.id,
    required this.fax,
    required this.homepage,
    required this.kategorien,
    required this.lat,
    required this.lng,
    required this.mobil,
    required this.ort,
    required this.plz,
    required this.strasse,
    required this.telefon,
    required this.telefon2,
    required this.urlDetails,
  });

  factory SingleItem.fromJson(Map<String, dynamic> json) {
    return SingleItem(
      beschreibung: json['beschreibung'],
      beschreibung2: json['beschreibung2'],
      beschreibung3: json['beschreibung3'],
      bezeichnung: json['bezeichnung'],
      bild: json['bild'],
      email: json['email'],
      extra1: json['extra1'],
      extra2: json['extra2'],
      extra3: json['extra3'],
      extra4: json['extra4'],
      extra5: json['extra5'],
      id: json['id'],
      fax: json['fax'],
      homepage: json['homepage'],
      kategorien: List<Kategorie>.from(json['kategorien'].map((x) => Kategorie.fromJson(x))),
      lat: json['lat'],
      lng: json['lng'],
      mobil: json['mobil'],
      ort: json['ort'],
      plz: json['plz'],
      strasse: json['strasse'],
      telefon: json['telefon'],
      telefon2: json['telefon2'],
      urlDetails: json['urlDetails'],
    );
  }
}

class Kategorie {
  final String bezeichnung;
  final int id;

  Kategorie({required this.bezeichnung, required this.id});

  factory Kategorie.fromJson(Map<String, dynamic> json) {
    return Kategorie(
      bezeichnung: json['bezeichnung'],
      id: json['id'],
    );
  }
}
