class FilterationDataModal {
  int? id;
  String? value;

  FilterationDataModal(this.id, this.value);

  FilterationDataModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = value;
    return data;
  }
}
