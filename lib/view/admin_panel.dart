import 'package:employe_task/const.dart';
import 'package:employe_task/provider/auth_provider.dart';
import 'package:employe_task/provider/user_provider.dart';
import 'package:employe_task/utlis/spacer/spacer.dart';
import 'package:employe_task/view/task_list_screen.dart';
import 'package:employe_task/widget/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminPanel extends StatefulWidget {
  final String? role;
  const AdminPanel({super.key, this.role});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  void initState() {
    super.initState();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (widget.role == "ADMIN") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.fetchUsersByType("USER");
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final taskProvider = Provider.of<UserProvider>(context, listen: false);
        final userId = authProvider.userData?["id"];
        print(userId);
        if (userId != null) {
          taskProvider.fetchTasks(userId);
        }
      });
    }
  }

  String getUserImage(String? userType) {
    switch (userType) {
      case "ADMIN":
        return admiImage;
      case "USER":
        return userIMage;
      default:
        return userIMage;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Employee Management",
          style: TextStyle(
            color: Colors.green,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey.shade100,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              authProvider.logout();
            },
          ),
        ],
      ),
      body:
          authProvider.userData == null
              ? const Center(
                child: Text(
                  "No User Logged In",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.grey.shade200,
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 52,
                              backgroundColor: Colors.green,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage(
                                  authProvider.userData?["profile"] ??
                                      getUserImage(
                                        authProvider.userData?["userType"],
                                      ),
                                ),
                                backgroundColor: Colors.grey.shade300,
                              ),
                            ),
                            hSpace18,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name: ${authProvider.userData!["name"]}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                vSpace4,
                                Text(
                                  "Mobile: ${authProvider.userData!["mobileno"]}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                vSpace4,
                                Text(
                                  "Member: ${authProvider.userData!["userType"]}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    vSpace18,
                    if (widget.role != "ADMIN")
                      Expanded(
                        child:
                            userProvider.isLoading
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : userProvider.tasks.isEmpty
                                ? const Center(
                                  child: Text("No tasks assigned yet"),
                                )
                                : ListView.builder(
                                  itemCount: userProvider.tasks.length,
                                  itemBuilder: (context, index) {
                                    final task = userProvider.tasks[index];
                                    final authProvider =
                                        Provider.of<AuthProvider>(
                                          context,
                                          listen: false,
                                        );

                                    return Card(
                                      elevation: 3,
                                      child: ListTile(
                                        leading: const Icon(Icons.task),
                                        title: Text(task.title ?? "No Title"),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Description: ${task.description}",
                                            ),
                                            Text(
                                              "Start: ${task.startDateTime?.toString() ?? 'N/A'}",
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      ),

                    // Show list only for admin role
                    if (widget.role == "ADMIN")
                      Expanded(
                        child:
                            userProvider.isLoading
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : userProvider.users.isEmpty
                                ? const Center(child: Text("No users found"))
                                : ListView.builder(
                                  itemCount: userProvider.users.length,
                                  itemBuilder: (context, index) {
                                    final user = userProvider.users[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => TaskListScreen(
                                                  taskfetctId: user.id,
                                                ),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            backgroundImage: AssetImage(
                                              getUserImage(user.userType),
                                            ),
                                          ),
                                          title: Text(user.name),
                                          subtitle: Text(" ${user.monbileno}"),
                                          trailing: IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          TaskListScreen(
                                                            taskfetctId:
                                                                user.id,
                                                          ),
                                                ),
                                              );
                                            },
                                            icon: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      ),
                  ],
                ),
              ),
      floatingActionButton:
          widget.role == "ADMIN"
              ? FloatingActionButton(
                onPressed: () => AssignTaskBottomSheet.show(context),
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add, color: Colors.white),
              )
              : FloatingActionButton(
                onPressed: () {
                  final taskProvider = Provider.of<UserProvider>(
                    context,
                    listen: false,
                  );
                  final userId = authProvider.userData?["id"];
                  print(userId);
                  if (userId != null) {
                    taskProvider.fetchTasks(userId);
                  }
                },
                backgroundColor: Colors.blue,
                child: const Icon(Icons.refresh, color: Colors.white),
              ),
    );
  }
}
