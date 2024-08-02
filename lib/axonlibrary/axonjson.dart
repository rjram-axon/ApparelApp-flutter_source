class Userdetails {
  String? username;
  String? password;
  String? loginstatus;
  int? userid;

  Userdetails(this.username, this.password, this.loginstatus, this.userid);

  Userdetails.fromJson(Map<String, dynamic> json) {
    username = json['Username'];
    password = json['Password'];
    loginstatus = json['LoginStatus'];
    userid = json['UserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Username'] = username;
    data['Password'] = password;
    data['LoginStatus'] = loginstatus;
    data['UserId'] = userid;
    return data;
  }
}
