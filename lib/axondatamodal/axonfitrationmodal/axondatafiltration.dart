class FilterationModal {
  int? id;
  String? value;

  FilterationModal(this.id, this.value);

  FilterationModal.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Value'] = value;
    return data;
  }
}
