class UpdateProductVideoStatus {
  String? status;
  Data? data;

  UpdateProductVideoStatus({this.status, this.data});

  UpdateProductVideoStatus.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? student;
  String? tourCode;
  bool? isView;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? id;

  Data(
      {this.student,
        this.tourCode,
        this.isView,
        this.sId,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.id});

  Data.fromJson(Map<String, dynamic> json) {
    student = json['student'];
    tourCode = json['tourCode'];
    isView = json['isView'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['student'] = student;
    data['tourCode'] = tourCode;
    data['isView'] = isView;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['id'] = id;
    return data;
  }
}