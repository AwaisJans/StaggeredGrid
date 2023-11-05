class DashboardModel {
  List<Dashboard>? dashboard;

  DashboardModel({this.dashboard});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    if (json["dashboard"] is List) {
      dashboard = json["dashboard"] == null
          ? null
          : (json["dashboard"] as List)
              .map((e) => Dashboard.fromJson(e))
              .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (dashboard != null) {
      _data["dashboard"] = dashboard?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Dashboard {
  String? title;
  String? navTitle;
  String? block;
  bool? microsite;
  String? pushInternalKey;
  bool? cellLayoutSameasModule;
  int? id;
  String? tintcolor;
  String? cellBackgroundColor;
  String? url;
  String? imagename;
  List<dynamic>? submodules;

  Dashboard(
      {this.title,
      this.navTitle,
      this.block,
      this.microsite,
      this.pushInternalKey,
      this.cellLayoutSameasModule,
      this.id,
      this.tintcolor,
      this.cellBackgroundColor,
      this.url,
      this.imagename,
      this.submodules});

  Dashboard.fromJson(Map<String, dynamic> json) {
    if (json["title"] is String) {
      title = json["title"];
    }
    if (json["navTitle"] is String) {
      navTitle = json["navTitle"];
    }
    if (json["block"] is String) {
      block = json["block"];
    }
    if (json["microsite"] is bool) {
      microsite = json["microsite"];
    }
    if (json["pushInternalKey"] is String) {
      pushInternalKey = json["pushInternalKey"];
    }
    if (json["cellLayoutSameasModule"] is bool) {
      cellLayoutSameasModule = json["cellLayoutSameasModule"];
    }
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["tintcolor"] is String) {
      tintcolor = json["tintcolor"];
    }
    if (json["cellBackgroundColor"] is String) {
      cellBackgroundColor = json["cellBackgroundColor"];
    }
    if (json["url"] is String) {
      url = json["url"];
    }
    if (json["imagename"] is String) {
      imagename = json["imagename"];
    }
    if (json["submodules"] is List) {
      submodules = json["submodules"] ?? [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["title"] = title;
    _data["navTitle"] = navTitle;
    _data["block"] = block;
    _data["microsite"] = microsite;
    _data["pushInternalKey"] = pushInternalKey;
    _data["cellLayoutSameasModule"] = cellLayoutSameasModule;
    _data["id"] = id;
    _data["tintcolor"] = tintcolor;
    _data["cellBackgroundColor"] = cellBackgroundColor;
    _data["url"] = url;
    _data["imagename"] = imagename;
    if (submodules != null) {
      _data["submodules"] = submodules;
    }
    return _data;
  }
}
