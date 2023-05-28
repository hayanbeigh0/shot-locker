class RoundDataFetchModel {
  RoundDataFetchModel({
    required this.results,
    required this.gameDetails,
  });

  final Results results;
  final List<GameDetail> gameDetails;

  factory RoundDataFetchModel.fromJson(Map<String, dynamic> json) =>
      RoundDataFetchModel(
        results: Results.fromJson(json['results']),
        gameDetails: List<GameDetail>.from(
          json['game_details'].map((x) => GameDetail.fromJson(x)),
        ).reversed.toList(),
      );
}

class GameDetail {
  GameDetail({
    required this.gameId,
    required this.myRound,
    required this.golfName,
    required this.date,
    required this.score,
    required this.holeDetails,
  });

  final String gameId;
  final String myRound;
  final String golfName;
  final String date;
  final String score;
  final List<HoleDetail> holeDetails;

  factory GameDetail.fromRawJson(dynamic str) => GameDetail.fromJson(str);

  factory GameDetail.fromJson(Map<String, dynamic> json) => GameDetail(
        gameId: json['game_id'].toString(),
        myRound: json['my_round'],
        golfName: json['golf_name'],
        date: json['date'],
        score: json['score'].toString(),
        holeDetails: List<HoleDetail>.from(
          json['hole_details'].map((x) => HoleDetail.fromJson(x)),
        ),
      );
}

class HoleDetail {
  HoleDetail({
    required this.hole,
    required this.pgaStrokesAvg,
    required this.strokesGainedAvg,
    required this.details,
  });

  final String hole;
  final String pgaStrokesAvg;
  final String strokesGainedAvg;
  final List<Detail> details;

  factory HoleDetail.fromRawJson(dynamic str) => HoleDetail.fromJson(str);

  factory HoleDetail.fromJson(Map<String, dynamic> json) => HoleDetail(
        hole: json['hole'],
        pgaStrokesAvg: json['pga_strokes_avg'].toString(),
        strokesGainedAvg: json['strokes_gained_avg'].toString(),
        details: List<Detail>.from(
          json['details'].map((x) => Detail.fromJson(x)),
        ),
      );
}

class Detail {
  Detail({
    required this.id,
    required this.startDistance,
    required this.surface,
    required this.penalty,
    required this.pgaStrokes,
    required this.strokesGained,
  });

  final String id;
  final String startDistance;
  final String surface;
  final String penalty;
  final String pgaStrokes;
  final String strokesGained;

  factory Detail.fromRawJson(dynamic str) => Detail.fromJson(str);

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        id: json['id'].toString(),
        startDistance: json['start_distance'].toString(),
        surface: json['surface'],
        penalty: json['penalty'].toString(),
        pgaStrokes: json['pga_strokes'].toStringAsFixed(2),
        strokesGained: json['strokes_gained'].toStringAsFixed(2),
      );
}

class Results {
  Results({
    required this.game,
    required this.scoreBoard,
    required this.best5Shots,
    required this.worst5Shots,
  });

  final List<String> game;
  final ScoreBoardModel scoreBoard;
  final List<St5Shot> best5Shots;
  final List<St5Shot> worst5Shots;

  factory Results.fromRawJson(dynamic str) => Results.fromJson(str);

  factory Results.fromJson(Map<String, dynamic> json) => Results(
        game: List<String>.from(json['game'].map((x) => x.toString())),
        scoreBoard: ScoreBoardModel.fromJson(json),
        best5Shots: List<St5Shot>.from(
          json['best_5_shots'].map((x) => St5Shot.fromJson(x)),
        ),
        worst5Shots: List<St5Shot>.from(
          json['worst_5_shots'].map((x) => St5Shot.fromJson(x)),
        ),
      );
}

class ScoreBoardModel {
  ScoreBoardModel({
    required this.course,
    required this.gameId,
    required this.score,
    required this.totalStrokes,
    required this.driver,
    required this.approches,
    required this.shortGames,
    required this.puttings,
  });

  final String course;
  final String gameId;
  final String score;
  final String totalStrokes;
  final String driver;
  final String approches;
  final String shortGames;
  final String puttings;

  factory ScoreBoardModel.fromJson(Map<String, dynamic> json) =>
      ScoreBoardModel(
        course: json['course'].toStringAsFixed(2),
        score: json['score'].toStringAsFixed(2),
        gameId: json['game'].toString(),
        totalStrokes: json['total_strokes'].toStringAsFixed(2),
        driver: json['driver'].toStringAsFixed(2),
        approches: json['approches'].toStringAsFixed(2),
        shortGames: json['short_games'].toStringAsFixed(2),
        puttings: json['puttings'].toStringAsFixed(2),
      );
}

class St5Shot {
  St5Shot({
    required this.sg,
    required this.game,
    required this.date,
    required this.holeNo,
    required this.roundNo,
    required this.shotNo,
    required this.startDistance,
    required this.surface,
  });

  final String sg;
  final String game;
  final String date;
  final String holeNo;
  final String roundNo;
  final String shotNo;
  final String startDistance;
  final String surface;

  factory St5Shot.fromRawJson(dynamic str) => St5Shot.fromJson(str);

  factory St5Shot.fromJson(Map<String, dynamic> json) => St5Shot(
        sg: json['SG'].toString(),
        game: json['game'].toString(),
        date: json['date'].toString(),
        holeNo: json['hole_no'].toString(),
        roundNo: json['round_no'].toString(),
        shotNo: json['shot_no'].toString(),
        startDistance: json['start_distance'].toString(),
        surface: json['surface'],
      );
}
