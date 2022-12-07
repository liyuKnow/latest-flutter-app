import 'package:flutter/material.dart';

import 'dart:io';

import 'package:permission_handler/permission_handler.dart'
    as permission_handler;
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
// import 'package:csv/csv.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as XLSIO;
import 'package:latest_app/src/widgets/common/custom_snack_bar.dart';

import 'package:latest_app/main.dart';

import 'package:latest_app/src/models/user_model.dart';
import 'package:latest_app/src/widgets/pages/user_list.dart';

enum MenuItems { import, export, sync }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Latest Build"),
        centerTitle: true,
        actions: [popupActions()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[const UserList()],
        ),
      ),
    );
  }

  // ^ FUNCTIONS
  PopupMenuButton<MenuItems> popupActions() {
    return PopupMenuButton<MenuItems>(
        onSelected: (value) {
          if (value == MenuItems.import) {
            _importDataExcel();
          } else if (value == MenuItems.export) {
            _exportData(); //  yellow comments
          } else if (value == MenuItems.sync) {
            _syncData();
          }
        },
        itemBuilder: ((context) => [
              PopupMenuItem(
                  value: MenuItems.import,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.download,
                        color: Colors.indigo,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text("Import Data"),
                    ],
                  )),
              PopupMenuItem(
                  value: MenuItems.export,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.upload,
                        color: Colors.indigo,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text("Export Data"),
                    ],
                  )),
              PopupMenuItem(
                  value: MenuItems.sync,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.import_export,
                        color: Colors.indigo,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text("Sync Data"),
                    ],
                  )),
            ]));
  }

  // Download From Downloads Folder
  _importDataExcel() async {
    // ^ CHECK PERMISSION
    var status =
        await permission_handler.Permission.manageExternalStorage.status;

    // ^ REQUEST PERMISSION
    if (status.isDenied) {
      await permission_handler.Permission.manageExternalStorage.request();
    }

    // ^ GET FILE FROM DOWNLOADS
    final directory = Directory('/storage/emulated/0/Download/');
    const fileName = "usersDownload.xlsx";

    final file = File(directory.path + fileName);

    var isFile = await file.exists();

    if (isFile) {
      // ^ SAVE IT TO A LOCAL VARIABLE
      List<String> rowDetail = [];

      var excelBytes = File(file.path).readAsBytesSync();
      var excelDecoder =
          SpreadsheetDecoder.decodeBytes(excelBytes, update: true);

      for (var table in excelDecoder.tables.keys) {
        for (var row in excelDecoder.tables[table]!.rows) {
          rowDetail.add('$row'.replaceAll('[', '').replaceAll(']', ''));
        }
      }

      // ^ CLEAR OBJECT BOX
      objectbox.userBox.removeAll();

      // ^ INSERT INTO OBJECT BOX
      for (var i = 1; i < rowDetail.length; i++) {
        var data = rowDetail[i].split(',');

        var firstName = data[1];
        var lastName = data[2];
        var gender = data[3];
        var country = data[4];

        User newUser = User(firstName, lastName, country, gender);
        objectbox.userBox.put(newUser);
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: CustomSnackBar(
          cardColor: Color.fromARGB(255, 103, 214, 112),
          bubbleColor: Color.fromARGB(255, 31, 160, 111),
          title: "Oh Great",
          message: "Data was imported successfully",
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
    } else {
      // SHOW An ERROR SNACKBAR
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: CustomSnackBar(
          cardColor: Color(0xFFC72C41),
          bubbleColor: Color(0xFF801336),
          title: "Oh Snap",
          message: "Something went wrong fetching data",
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
    }
  }

  _importDataCSV() async {
    // ^ CHECK PERMISSION
    var status =
        await permission_handler.Permission.manageExternalStorage.status;

    // ^ REQUEST PERMISSION
    if (status.isDenied) {
      await permission_handler.Permission.manageExternalStorage.request();
    }

    // ^ GET FILE FROM DOWNLOADS
    final directory = Directory('/storage/emulated/0/Download/');
    const fileName = "usersDownload.csv";
    final file = File(directory.path + fileName);

    // ^ SAVE IT TO A LOCAL VARIABLE
    List<String> rowDetail = [];

    var excelBytes = File(file.path).readAsBytesSync();
    var excelDecoder = SpreadsheetDecoder.decodeBytes(excelBytes, update: true);

    for (var table in excelDecoder.tables.keys) {
      for (var row in excelDecoder.tables[table]!.rows) {
        rowDetail.add('$row'.replaceAll('[', '').replaceAll(']', ''));
      }
    }

    // ^ CLEAR OBJECT BOX
    objectbox.userBox.removeAll();

    // ^ INSERT INTO OBJECT BOX
    for (var row in rowDetail) {
      var data = row.split(',');

      var firstName = data[1];
      var lastName = data[2];
      var country = data[3];
      var gender = data[4];

      User newUser = User(firstName, lastName, country, gender);
      objectbox.userBox.put(newUser);
    }
  }

  Future<void> _exportData() async {
    // ^ export current database data to downloads folder

    // Create a new Excel document.
    final XLSIO.Workbook workbook = XLSIO.Workbook();
    //Accessing worksheet via index.
    final XLSIO.Worksheet sheet = workbook.worksheets[0];

    // ADD THE HEADERS
    sheet.getRangeByName('A1').setText('FirstName');
    sheet.getRangeByName('B1').setText('LastName');
    sheet.getRangeByName('C1').setText('Gender');
    sheet.getRangeByName('D1').setText('Country');

    // GET ALL DATA FROM OBJECT BOX
    List<User> users = objectbox.userBox.getAll();

    for (var i = 2; i < users.length; i++) {
      sheet.getRangeByName('A$i').setText((users[i].firstName).toString());
      sheet.getRangeByName('B$i').setText((users[i].lastName).toString());
      sheet.getRangeByName('C$i').setText((users[i].gender).toString());
      sheet.getRangeByName('D$i').setText((users[i].country).toString());
    }

    final List<int> bytes = workbook.saveAsStream();

    final directory = Directory('/storage/emulated/0/Download/');
    const fileName = "NewNewUsersDownload.xlsx";
    final file = File(directory.path + fileName);

    file.writeAsBytes(bytes);

    //Dispose the workbook.
    workbook.dispose();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: CustomSnackBar(
        cardColor: Color(0xFFC72C41),
        bubbleColor: Color(0xFF801336),
        title: "Oh Snap",
        message: "Something went wrong",
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ));
  }

  _syncData() {
    // send current database data to API
  }
}
