import 'package:flutter/material.dart';
import 'package:latest_app/src/widgets/pages/home_page.dart';
import 'package:latest_app/src/models/updated_location.dart';
import 'package:latest_app/src/models/user_model.dart';
import 'package:latest_app/main.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.userId});

  final int userId;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  User? user;
  UpdatedLocation? updatedLocation;

  @override
  void initState() {
    super.initState();
    user = objectbox.userBox.get(widget.userId)!;

    updatedLocation = objectbox.updatedLocationBox.get(1)!;

    print(updatedLocation?.lat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("User Detail"),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              // ^ NAVIGATE BACK TO HOME
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: detailCard(),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(12),
            //   child: locationCard(),
            // ),
          ],
        ));
  }

  Widget detailCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "USER DETAILS",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                detailRow("First Name ", user?.firstName),
                detailRow("Last Name ", user?.lastName),
                detailRow("Gender ", user?.country),
                detailRow("Country ", user?.gender),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Widget locationCard() {
  //   return Card(
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     child: Container(
  //       padding: EdgeInsets.all(16),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               const Text(
  //                 "UPDATED LOCATION DETAILS",
  //                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //               ),
  //               SizedBox(
  //                 height: 20,
  //               ),
  //               detailRow("First Name ", user?.firstName),
  //               detailRow("Lat ", updatedLocation?.lat.toString()),
  //               detailRow("Long ", updatedLocation?.lat.toString()),
  //               // detailRow("Updated At ", user?.updatedAt.toString()),
  //             ],
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Row detailRow(String column, String? data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          column,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
        ),
        Text("$data",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300))
      ],
    );
  }
}
