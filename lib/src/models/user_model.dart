import 'package:objectbox/objectbox.dart';

@Entity()
class User {
  @Id()
  int id;

  String firstName;
  String lastName;
  String country;
  String gender;
  bool completed;

  User(this.firstName, this.lastName, this.country, this.gender,
      {this.id = 0, this.completed = false});

  bool setCompleted() {
    completed = true;
    return completed;
  }
}
