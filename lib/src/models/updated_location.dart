import 'package:objectbox/objectbox.dart';
import "package:latest_app/src/models/user_model.dart";

@Entity()
class UpdatedLocation {
  @Id()
  int id;

  double lat;
  double long;

  @Property(type: PropertyType.date)
  DateTime? updatedAt;

  // RECORD IDENTIFIER AND ONE TO ONE RELATION
  final userId = ToOne<User>();

  UpdatedLocation(this.lat, this.long, {this.id = 0, this.updatedAt});
}
