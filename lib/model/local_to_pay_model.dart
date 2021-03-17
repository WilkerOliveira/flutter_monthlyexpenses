class LocalToPayModel {
  String id;
  String description;

  LocalToPayModel();

  LocalToPayModel.fromJson(Map<String, dynamic> json) {
    this.description = json['description'];
    this.id = json['id'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['id'] = this.id;
    return data;
  }
}
