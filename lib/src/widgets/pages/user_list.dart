import 'package:flutter/material.dart';

import 'package:latest_app/main.dart';
import 'package:latest_app/src/models/user_model.dart';
import 'package:latest_app/src/widgets/pages/qr_page.dart';
import 'package:latest_app/src/widgets/pages/detail_page.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: StreamBuilder<List<User>>(
            stream: objectbox.getUsers(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                // TODO display a user-friendly error message
                debugPrintStack(stackTrace: snapshot.stackTrace);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  ],
                );
              } else {
                final users = snapshot.data!;

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];

                    return ListTile(
                      title: Text(user.firstName),
                      subtitle: Text(user.gender),
                      trailing: trailingIcon(context, user.completed, user.id),
                    );
                  },
                );
              }
            }));
  }

  IconButton trailingIcon(BuildContext context, bool completed, int id) {
    if (completed) {
      return IconButton(
        icon: const Icon(Icons.info_outline),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => DetailPage(userId: id)),
            // QRPage(title: "QR For ${user.id}")),
          );
        },
      );
      ;
    } else {
      return IconButton(
        icon: const Icon(Icons.qr_code),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => QRPage(userId: id)),
          );
        },
      );
    }
  }
}
