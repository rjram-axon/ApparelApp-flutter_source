class StyleGalleryDataModal {
  int? styleid;
  String? imagepath;
  String? imagetite;

  StyleGalleryDataModal(this.styleid, this.imagepath, this.imagetite);

  StyleGalleryDataModal.fromJson(Map<String, dynamic> json) {
    styleid = json['StyleRowid'];
    imagepath = json['Imgpath'];
    imagetite = json['Imgtitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StyleRowid'] = styleid;
    data['Imgpath'] = imagepath;
    data['Imgtitle'] = imagetite;
    return data;
  }
}
