class DriverModel {
  DriverModel({
    required this.driver,
    required this.totAl,
  });

  final String driver;
  final String totAl;

  factory DriverModel.fromJson(Map<String, dynamic> json) => DriverModel(
        driver: json['driver'].toString(),
        totAl: json['total'].toString(),
      );
}

//Approaches
class ApproachesModel {
  ApproachesModel({
    required this.the226Yds,
    required this.the176226Yds,
    required this.the126175Yds,
    required this.the50125Yds,
  });

  final The226Yds the226Yds;
  final The176226Yds the176226Yds;
  final The126175Yds the126175Yds;
  final The50125Yds the50125Yds;

  factory ApproachesModel.fromJson(Map<String, dynamic> json) =>
      ApproachesModel(
        the226Yds: The226Yds.fromJson(json['_226_yds']),
        the176226Yds: The176226Yds.fromJson(json['_176_226_yds']),
        the126175Yds: The126175Yds.fromJson(json['_126_175_yds']),
        the50125Yds: The50125Yds.fromJson(json['_50_125_yds']),
      );
}

class The126175Yds {
  The126175Yds({
    required this.val126175Yds,
    required this.total126175Yds,
  });

  final String val126175Yds;
  final String total126175Yds;

  factory The126175Yds.fromJson(Map<String, dynamic> json) => The126175Yds(
        val126175Yds: json['val_126_175_yds'].toStringAsFixed(2),
        total126175Yds: json['total_126_175_yds'].toStringAsFixed(2),
      );
}

class The176226Yds {
  The176226Yds({
    required this.val176226Yds,
    required this.total176226Yds,
  });

  final String val176226Yds;
  final String total176226Yds;

  factory The176226Yds.fromJson(Map<String, dynamic> json) => The176226Yds(
        val176226Yds: json['val_176_226_yds'].toStringAsFixed(2),
        total176226Yds: json['total_176_226_yds'].toStringAsFixed(2),
      );
}

class The226Yds {
  The226Yds({
    required this.val226Yds,
    required this.total226Yds,
  });

  final String val226Yds;
  final String total226Yds;

  factory The226Yds.fromJson(Map<String, dynamic> json) => The226Yds(
        val226Yds: json['val_226_yds'].toStringAsFixed(2),
        total226Yds: json['total_226_yds'].toStringAsFixed(2),
      );
}

class The50125Yds {
  The50125Yds({
    required this.val50125Yds,
    required this.total50125Yds,
  });

  final String val50125Yds;
  final String total50125Yds;

  factory The50125Yds.fromJson(Map<String, dynamic> json) => The50125Yds(
        val50125Yds: json['val_50_125_yds'].toStringAsFixed(2),
        total50125Yds: json['total_50_125_yds'].toStringAsFixed(2),
      );
}

//Short Game
class ShortGameModel {
  ShortGameModel({
    required this.the3150Yds,
    required this.the1030Yds,
    required this.bunker,
  });

  final The3150Yds the3150Yds;
  final The1030Yds the1030Yds;
  final Bunker bunker;

  factory ShortGameModel.fromJson(Map<String, dynamic> json) => ShortGameModel(
        the3150Yds: The3150Yds.fromJson(json['_31_50_yds']),
        the1030Yds: The1030Yds.fromJson(json['_10_30_yds']),
        bunker: Bunker.fromJson(json['bunker']),
      );
}

class Bunker {
  Bunker({
    required this.valBunker,
    required this.totalBunker,
  });

  final String valBunker;
  final String totalBunker;

  factory Bunker.fromJson(Map<String, dynamic> json) => Bunker(
        valBunker: json['val_bunker'].toString(),
        totalBunker: json['total_bunker'].toString(),
      );
}

class The1030Yds {
  The1030Yds({
    required this.val1030Yds,
    required this.total1030Yds,
  });

  final String val1030Yds;
  final String total1030Yds;

  factory The1030Yds.fromJson(Map<String, dynamic> json) => The1030Yds(
        val1030Yds: json['val_10_30_yds'].toString(),
        total1030Yds: json['total_10_30_yds'].toString(),
      );
}

class The3150Yds {
  The3150Yds({
    required this.val3150Yds,
    required this.total3150Yds,
  });

  final String val3150Yds;
  final String total3150Yds;

  factory The3150Yds.fromJson(Map<String, dynamic> json) => The3150Yds(
        val3150Yds: json['val_31_50_yds'].toString(),
        total3150Yds: json['total_31_50_yds'].toString(),
      );
}

//Putting
class PuttingModel {
  PuttingModel({
    required this.over15,
    required this.the515,
    required this.under5,
  });

  final Over15 over15;
  final The515 the515;
  final Under5 under5;

  factory PuttingModel.fromJson(Map<String, dynamic> json) => PuttingModel(
        over15: Over15.fromJson(json['over_15']),
        the515: The515.fromJson(json['_5_15']),
        under5: Under5.fromJson(json['under5']),
      );
}

class Over15 {
  Over15({
    required this.valOver15,
    required this.totalOver15,
  });

  final String valOver15;
  final String totalOver15;

  factory Over15.fromJson(Map<String, dynamic> json) => Over15(
        valOver15: json['val_over15'].toStringAsFixed(2),
        totalOver15: json['total_over15'].toStringAsFixed(2),
      );
}

class The515 {
  The515({
    required this.val515,
    required this.total515,
  });

  final String val515;
  final String total515;

  factory The515.fromJson(Map<String, dynamic> json) => The515(
        val515: json['val_5_15'].toString(),
        total515: json['total_5_15'].toString(),
      );
}

class Under5 {
  Under5({
    required this.valUnder5,
    required this.totalUnder5,
  });

  final String valUnder5;
  final String totalUnder5;

  factory Under5.fromJson(Map<String, dynamic> json) => Under5(
        valUnder5: json['val_under5'].toString(),
        totalUnder5: json['total_under5'].toString(),
      );
}

//