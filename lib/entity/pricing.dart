//TODO merge into another file, maybe carpark controller
class Pricing {
  String? help;
  bool? success;
  Result? result;

  Pricing({this.help, this.success, this.result});

  Pricing.fromJson(Map<String, dynamic> json) {
    help = json['help'];
    success = json['success'];
    result = json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['help'] = this.help;
    data['success'] = this.success;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? resourceId;
  List<Fields>? fields;
  String? q;
  List<Records>? records;
  Links? lLinks;
  int? total;

  Result({this.resourceId, this.fields, this.q, this.records, this.lLinks, this.total});

  Result.fromJson(Map<String, dynamic> json) {
    resourceId = json['resource_id'];
    if (json['fields'] != null) {
      fields = <Fields>[];
      json['fields'].forEach((v) {
        fields!.add(new Fields.fromJson(v));
      });
    }
    q = json['q'];
    if (json['records'] != null) {
      records = <Records>[];
      json['records'].forEach((v) {
        records!.add(new Records.fromJson(v));
      });
    }
    lLinks = json['_links'] != null ? new Links.fromJson(json['_links']) : null;
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resource_id'] = this.resourceId;
    if (this.fields != null) {
      data['fields'] = this.fields!.map((v) => v.toJson()).toList();
    }
    data['q'] = this.q;
    if (this.records != null) {
      data['records'] = this.records!.map((v) => v.toJson()).toList();
    }
    if (this.lLinks != null) {
      data['_links'] = this.lLinks!.toJson();
    }
    data['total'] = this.total;
    return data;
  }
}

class Fields {
  String? type;
  String? id;

  Fields({this.type, this.id});

  Fields.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    return data;
  }
}

class Records {
  String? category;
  String? saturdayRate;
  double? rank;
  String? sFullCount;
  String? sundayPublicholidayRate;
  String? carpark;
  String? weekdaysRate1;
  String? weekdaysRate2;
  int? iId;

  Records(
      {this.category,
      this.saturdayRate,
      this.rank,
      this.sFullCount,
      this.sundayPublicholidayRate,
      this.carpark,
      this.weekdaysRate1,
      this.weekdaysRate2,
      this.iId});

  Records.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    saturdayRate = json['saturday_rate'];
    rank = json['rank'];
    sFullCount = json['_full_count'];
    sundayPublicholidayRate = json['sunday_publicholiday_rate'];
    carpark = json['carpark'];
    weekdaysRate1 = json['weekdays_rate_1'];
    weekdaysRate2 = json['weekdays_rate_2'];
    iId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['saturday_rate'] = this.saturdayRate;
    data['rank'] = this.rank;
    data['_full_count'] = this.sFullCount;
    data['sunday_publicholiday_rate'] = this.sundayPublicholidayRate;
    data['carpark'] = this.carpark;
    data['weekdays_rate_1'] = this.weekdaysRate1;
    data['weekdays_rate_2'] = this.weekdaysRate2;
    data['_id'] = this.iId;
    return data;
  }
}

class Links {
  String? start;
  String? next;

  Links({this.start, this.next});

  Links.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start'] = this.start;
    data['next'] = this.next;
    return data;
  }
}
