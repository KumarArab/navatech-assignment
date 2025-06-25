import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'album_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class AlbumModel extends HiveObject{
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final int? userId;
  @HiveField(2)
  final String? title;

   AlbumModel({this.id, this.userId, this.title});

  factory AlbumModel.fromJson(Map<String, dynamic> json) => _$AlbumModelFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumModelToJson(this);
}
