class CourseListModel {
  final String id;
  final String courseName;
  CourseListModel({
    required this.id,
    required this.courseName,
  });

  factory CourseListModel.fromMap(Map<String, dynamic> map) {
    return CourseListModel(
      id: map['id'].toString(),
      courseName: map['course'].toString(),
    );
  }
}

class CourseWithDistanceListModel {
  final String distance;
  final String courseName;
  final int id;
  CourseWithDistanceListModel({
    required this.distance,
    required this.courseName,
    required this.id
  });

  factory CourseWithDistanceListModel.fromMap(Map<String, dynamic> map) {
    return CourseWithDistanceListModel(
        id: map['id'],
        courseName: map['course_name'].toString(),
        distance: (map['distance'] ?? '').toString()

    );
  }
}
