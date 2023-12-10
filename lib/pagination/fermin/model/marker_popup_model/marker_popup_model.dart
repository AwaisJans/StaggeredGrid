/// singleItem : {"bezeichnung":"Empfinger Getränkemarkt","id":489,"ort":"Empfingen","plz":"72186","strasse":"Horber Straße 99","urlDetails":"https://www.empfingen.de/app-v3-nativ?action=getFirmaDetails&singleItemId=489&cHash=df5d652934f392199372620825d37dac"}
/// status : "ok"


class PopupItems {
  SingleItem? singleItem;
  String? status;

  PopupItems({this.singleItem, this.status});

  factory PopupItems.fromJson(Map<String, dynamic> json) {
    return PopupItems(
      singleItem: json['singleItem'] != null ? SingleItem.fromJson(json['singleItem']) : null,
      status: json['status'],
    );
  }
}

class SingleItem {
  String? bezeichnung;
  int? id;
  String? ort;
  String? plz;
  String? strasse;
  String? urlDetails;

  SingleItem({this.bezeichnung, this.id, this.ort, this.plz, this.strasse, this.urlDetails});

  factory SingleItem.fromJson(Map<String, dynamic> json) {
    return SingleItem(
      bezeichnung: json['bezeichnung'],
      id: json['id'],
      ort: json['ort'],
      plz: json['plz'],
      strasse: json['strasse'],
      urlDetails: json['urlDetails'],
    );
  }
}