import 'package:flutter/material.dart';
import 'package:latest_app/src/widgets/pages/home_page.dart';
import 'package:location/location.dart';

import 'package:latest_app/src/helper/object_box.dart';
import 'package:latest_app/src/models/user_model.dart';
import 'package:latest_app/src/models/updated_location.dart';
import 'package:latest_app/main.dart';
import 'package:latest_app/src/widgets/common/custom_snack_bar.dart';

class UpdateFoundUser extends StatefulWidget {
  final String value;
  final int userId;
  final Function() screenClosed;

  const UpdateFoundUser({
    Key? key,
    required this.value,
    required this.screenClosed,
    required this.userId,
  }) : super(key: key);

  @override
  State<UpdateFoundUser> createState() => _UpdateFoundUserState();
}

class _UpdateFoundUserState extends State<UpdateFoundUser> {
  // ^ CONTROLLERS
  final _userFirstNameController = TextEditingController();
  final _userLastNameController = TextEditingController();
  final _userCountryController = TextEditingController();
  final _userGenderController = TextEditingController();

  // ^ VALIDATION FLAGS
  bool _validateFirstName = false;
  bool _validateLastName = false;
  bool _validateCountry = false;
  bool _validateGender = false;

  // ^ INITIALISE STATE
  @override
  void initState() {
    var user = objectbox.userBox.get(widget.userId);
    setState(() {
      _userFirstNameController.text = user?.firstName ?? '';
      _userLastNameController.text = user?.lastName ?? '';
      _userCountryController.text = user?.country ?? '';
      _userGenderController.text = user?.gender ?? '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update User"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            // ^ NAVIGATE BACK TO HOME
            returnHome(context);
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 20.0,
            ),
            TextField(
                enabled: false,
                controller: _userFirstNameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Enter Firstname',
                  labelText: 'Firstname',
                  errorText:
                      _validateFirstName ? 'Name Value Can\'t Be Empty' : null,
                )),
            const SizedBox(
              height: 10.0,
            ),
            TextField(
                enabled: false,
                controller: _userLastNameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Enter Lastname ',
                  labelText: 'Lastname ',
                  errorText: _validateLastName
                      ? 'Lastname  Value Can\'t Be Empty'
                      : null,
                )),
            const SizedBox(
              height: 10.0,
            ),
            TextField(
                controller: _userCountryController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Enter Country',
                  labelText: 'Country',
                  errorText:
                      _validateCountry ? 'Country Value Can\'t Be Empty' : null,
                )),
            const SizedBox(
              height: 10.0,
            ),
            TextField(
                controller: _userGenderController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Enter Gender',
                  labelText: 'Gender',
                  errorText:
                      _validateGender ? 'Gender Value Can\'t Be Empty' : null,
                )),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.teal,
                        textStyle: const TextStyle(fontSize: 15)),
                    onPressed: () async {
                      setState(() {
                        _userCountryController.text.isEmpty
                            ? _validateCountry = true
                            : _validateCountry = false;
                        _userGenderController.text.isEmpty
                            ? _validateGender = true
                            : _validateGender = false;
                      });

                      if (_validateCountry == false &&
                          _validateGender == false) {
                        // ^ UPDATE DATA LOGIC HERE
                        print("DO YOUR THING GURU");
                        _updateUser();
                        returnHome(context);
                      }
                    },
                    child: const Text('Update Details')),
                const SizedBox(
                  width: 10.0,
                ),
                TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        textStyle: const TextStyle(fontSize: 15)),
                    onPressed: () {
                      _userCountryController.text = '';
                      _userGenderController.text = '';
                    },
                    child: const Text('Clear Details'))
              ],
            )
          ]),
        ),
      ),
    );
  }

  void returnHome(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  Future _updateUser() async {
    // ^ LOCATION SERVICE ON AND PERMISSION
    var location = Location();

    if (!await location.serviceEnabled()) {
      if (!await location.requestService()) {
        return;
      }
    }

    var permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission != PermissionStatus.granted) {
        return;
      }
    }
    // ^ GET LOCATION DATA
    var loc = await location.getLocation();
    print("${loc.latitude} ${loc.longitude}");

    // & LIVE LISTENER OF LOCATION => CAN BE USED TO TRACK SUDDEN LOCATION CHANGES
    // location.onLocationChanged.listen((LocationData loc) {
    //   print("${loc.latitude} ${loc.longitude}");
    // });

    // ^ UPDATE USER AND COMPLETED FLAG
    // & get user by id
    User? user = await objectbox.getUser(widget.userId);
    print("User Completed State Before");
    print(user?.completed);
    print("+++++++++++++++++++++++++++++++++");

    print("User Location Data");
    print("Lat : ${loc.latitude}, and Long ${loc.longitude}");
    print("+++++++++++++++++++++++++++++++++");

    // & ONLY FOR LIVE LOCATIONS
    if (loc.latitude != null) {
      objectbox.addUpdatedLocation(
          loc.latitude, loc.longitude, DateTime(2022), user!);

      List<UpdatedLocation> updatedLocations;

      updatedLocations = objectbox.updatedLocationBox.getAll();

      for (var locations in updatedLocations) {
        print(locations.userId);
      }
      // WHERE UPDATING LOGIC
      objectbox.setCompleted(user);
    } else if (loc.latitude == null) {
      // Fetch Old Locations
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: CustomSnackBar(
          cardColor: Color(0xFFC72C41),
          bubbleColor: Color(0xFF801336),
          title: "Oh Snap",
          message: "Something went Updating record",
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
    }
  }
}
