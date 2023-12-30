import 'package:freezed_annotation/freezed_annotation.dart';
part 'listitem.freezed.dart';

@freezed
abstract class ListItem with _$ListItem {
  const factory ListItem({
    required String id,
    required String title,
    required String body,
    required String overview,
    required DateTime publishedAt,
    required String eyecatching,
  }) = _ListItem;

  factory ListItem.fromJSON(Map<String, dynamic> json) {
    // return _$ListItemFromJson(json);

    return ListItem(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      overview: json['overview'] as String,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      eyecatching: json['eyecatching']['url'] as String,
    );
  }
}
