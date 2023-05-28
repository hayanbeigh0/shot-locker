class RangeDataModel {
  final String heading;
  final List<RangeSubHeading> rangeSubHeading;
  RangeDataModel({
    required this.heading,
    required this.rangeSubHeading,
  });
}

class RangeSubHeading {
  final String id;
  final String subHeading;
  RangeSubHeading({
    required this.id,
    required this.subHeading,
  });

  factory RangeSubHeading.fromMap(Map<String, dynamic> map) {
    return RangeSubHeading(
      id: map['id'].toString(),
      subHeading: map['heading'].toString(),
    );
  }

  factory RangeSubHeading.fromJson(dynamic source) =>
      RangeSubHeading.fromMap(source);
}

class RangeArticleModel {
  RangeArticleModel({
    required this.id,
    required this.headings,
    required this.title,
    required this.description,
    required this.fileLink,
  });

  final int id;
  final String headings;
  final String title;
  final String description;
  final String fileLink;

  factory RangeArticleModel.fromRawJson(dynamic str) =>
      RangeArticleModel.fromJson(str);

  factory RangeArticleModel.fromJson(Map<String, dynamic> json) =>
      RangeArticleModel(
        id: json['id'],
        headings: json['headings'],
        title: json['title'],
        description: json['description'],
        fileLink: json['file_link'],
      );
}
