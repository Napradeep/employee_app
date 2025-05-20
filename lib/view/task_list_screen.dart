import 'package:employe_task/provider/auth_provider.dart';
import 'package:employe_task/provider/user_provider.dart';
import 'package:employe_task/utlis/spacer/spacer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskListScreen extends StatefulWidget {
  final String taskfetctId;
  const TaskListScreen({super.key, required this.taskfetctId});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String formatDateTime(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskProvider = Provider.of<UserProvider>(context, listen: false);

      print('User ID in TaskListScreen: ${widget.taskfetctId}');
      taskProvider.fetchTasks(widget.taskfetctId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tasks")),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          // You may have a loading flag in your provider
          if (userProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userProvider.tasks.isEmpty) {
            return const Center(child: Text("No tasks found."));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: userProvider.tasks.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final task = userProvider.tasks[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title ?? "No Title",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      vSpace4,
                      Text(
                        "Employee: ${task.employee ?? 'N/A'}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      vSpace4,
                      Text(
                        task.description ?? "No Description",
                        style: const TextStyle(fontSize: 14),
                      ),
                      vSpace8,
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          hSpace8,
                          Text(
                            "Start: ${task.startDateTime != null ? formatDateTime(task.startDateTime) : 'N/A'}",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      vSpace4,
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          hSpace8,
                          Text(
                            "End: ${task.endDateTime != null ? formatDateTime(task.endDateTime) : 'N/A'}",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
