class RoundData {
  bool isChecked;
  final String id;
  final String roundName;
  final String golfName;
  final String entryDate;
  final String holeType;
  RoundData({
    this.isChecked = false,
    this.id = '',
    required this.roundName,
    this.golfName = '',
    this.entryDate = '',
    this.holeType = '',
  });

  factory RoundData.fromMap(Map<String, dynamic> map) {
    return RoundData(
      isChecked: false,
      id: map['id'].toString(),
      roundName: map['my_round'].toString(),
      golfName: map['golf_name'].toString(),
      entryDate: map['entry_date'].toString(),
      holeType: map['hole_type'].toString(),
    );
  }

  factory RoundData.fromJson(dynamic source) => RoundData.fromMap(source);
}
