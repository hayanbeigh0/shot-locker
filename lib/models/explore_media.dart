import 'dart:convert';

import 'package:equatable/equatable.dart';

class ExploreMedia extends Equatable {
  final String? title;
  final String? media;
  final String? description;

  const ExploreMedia({
    required this.title,
    required this.media,
    required this.description,
  });

  ExploreMedia copyWith({
    String? title,
    String? media,
    String? description,
  }) {
    return ExploreMedia(
      title: title ?? this.title,
      media: media ?? this.media,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'media': media,
      'description': description,
    };
  }

  factory ExploreMedia.fromMap(Map<String, dynamic> map) {
    return ExploreMedia(
      title: map['title'],
      media: map['media'],
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ExploreMedia.fromJson(String source) =>
      ExploreMedia.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [title, media, description];
}
