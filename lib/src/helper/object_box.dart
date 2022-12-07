import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:latest_app/objectbox.g.dart';
import 'package:latest_app/src/models/user_model.dart';
import 'package:latest_app/src/models/updated_location.dart';

class ObjectBox {
  // DEFINE STORE
  late final Store store;

  // DEFINE BOXES
  late final Box<User> userBox;
  late final Box<UpdatedLocation> updatedLocationBox;

  /// CREATE AN INSTANCE OF OBJECTBOX TO USE THROUGHOUT THE APP.
  ObjectBox._create(this.store) {
    userBox = Box<User>(store);
    updatedLocationBox = Box<UpdatedLocation>(store);
  }

  static Future<ObjectBox> create() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final databaseDirectory = p.join(documentsDirectory.path, "obx-report-db");

    final store = await openStore(directory: databaseDirectory);
    return ObjectBox._create(store);
  }

  /// ! CREATE CRUD OPERATIONS
  /// * ADD RECORD(user)
  /// * GET RECORD(user)
  /// * GET ALL RECORDS(users)
  /// * UPDATE RECORD(user)
  /// * ADD UPDATED LOCATION OF RECORD(user)
  /// * GET UPDATED LOCATION OF RECORD(user)

  // ADD USER
  void addUser(
      String firstName, String lastName, String country, String gender) {
    User newUser = User(firstName, lastName, country, gender);
    userBox.put(newUser);
  }

  void setCompleted(User? user) {
    user?.completed = true;
    userBox.put(user!);
  }

  // UPDATE NAD INSERT IN ONE
  void putUser(User user) {
    userBox.put(user);
  }

  // GET ALL USERS
  Stream<List<User>> getUsers() {
    return userBox
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  //  GET USER BY ID
  User? getUser(int id) {
    return userBox.get(id);
  }

  // ADD UPDATED LOCATION
  void addUpdatedLocation(
      double? lat, double? long, DateTime updatedAt, User userId) {
    UpdatedLocation newUpdatedLocation =
        UpdatedLocation(lat!, long!, updatedAt: updatedAt);
    newUpdatedLocation.userId.target = userId;

    updatedLocationBox.put(newUpdatedLocation);
  }

  Stream<List<UpdatedLocation>> getUpdatedLocations() {
    return updatedLocationBox
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
  // GET UPDATED LOCATION FOR A USER
  // UpdatedLocation? getUpdatedLocation(User user) {
  //   return updatedLocationBox.query(user);
  // }
}
