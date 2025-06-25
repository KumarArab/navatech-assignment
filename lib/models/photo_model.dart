import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'photo_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class PhotoModel extends HiveObject{
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final int? albumId;
  @HiveField(2)
  final String? title;
  @HiveField(3)
  final String? url;
  @HiveField(4)
  final String? thumbnailUrl;

   PhotoModel({this.id, this.albumId, this.title, this.url, this.thumbnailUrl});

  factory PhotoModel.fromJson(Map<String, dynamic> json) => _$PhotoModelFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoModelToJson(this);
}
