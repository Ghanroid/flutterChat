class Userprofile {
  String? uid;
  String? name;
  String? pfpurl;
  Userprofile({required this.uid, required this.name, required this.pfpurl});

  Userprofile.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    pfpurl = json['pfpurl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['name'] = name;
    data['pfpurl'] = pfpurl;
    data['uid'] = uid;
    return data;
  }
}
