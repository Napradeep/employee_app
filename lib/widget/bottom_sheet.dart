import 'dart:developer';

import 'package:employe_task/model/task_model.dart';
import 'package:employe_task/provider/auth_provider.dart';
import 'package:employe_task/provider/send_notifcaion.dart';
import 'package:employe_task/utlis/messenger/snackbar.dart';
import 'package:employe_task/utlis/messenger/toaster.dart';
import 'package:intl/intl.dart';

import 'package:employe_task/utlis/spacer/spacer.dart';
import 'package:employe_task/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/user_provider.dart';

class AssignTaskBottomSheet {
  static void show(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? selectedUserId;
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime? startDate;
    DateTime? endDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Assign Task",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    vSpace8,

                    /// Employee Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedUserId,
                      hint: const Text("Select Employee"),
                      items:
                          userProvider.users.map((user) {
                            return DropdownMenuItem<String>(
                              value: user.id,
                              child: Text(user.name),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedUserId = value;
                        });
                      },
                    ),
                    vSpace8,

                    /// Title
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: "Task Title",
                      ),
                    ),
                    vSpace8,

                    /// Description
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Task Description",
                      ),
                    ),
                    vSpace8,

                    /// Start Date
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        startDate == null
                            ? "Select Start Date & Time"
                            : "Start: ${DateFormat('dd/MM/yyyy').format(startDate!)} and ${DateFormat('hh:mm a').format(startDate!)}",
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2023),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              startDate = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                            });
                          }
                        }
                      },
                    ),

                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        endDate == null
                            ? "Select End Date & Time"
                            : "End: ${DateFormat('dd/MM/yyyy').format(endDate!)} and ${DateFormat('hh:mm a').format(endDate!)}",
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2023),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              endDate = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                            });
                          }
                        }
                      },
                    ),

                    vSpace8, vSpace8,

                    SizedBox(
                      width: double.infinity,
                      child: Button(
                        // Add this inside your onPressed:
                        onpressed: () async {
                          if (selectedUserId != null &&
                              titleController.text.isNotEmpty &&
                              descriptionController.text.isNotEmpty &&
                              startDate != null &&
                              endDate != null) {
                            // Find selected user details
                            final selectedUser = userProvider.users.firstWhere(
                              (user) => user.id == selectedUserId,
                            );

                            final currentUser =
                                Provider.of<AuthProvider>(
                                  context,
                                  listen: false,
                                ).userData;
                            final senderMobile = currentUser?['mobileno'] ?? '';
                            final senderUserId = currentUser?['id'] ?? '';
                            final senderName = currentUser?['name'] ?? '';

                            final task = TaskModel(
                              employee: selectedUser.name,
                              title: titleController.text.trim(),
                              description: descriptionController.text.trim(),
                              startDateTime: startDate!,
                              endDateTime: endDate!,
                              token: selectedUser.deviceToken ?? '',
                              senderMobile: senderMobile,
                              senderUserId: senderUserId,
                              senderName: senderName,
                              recivedId: selectedUser.id,
                            );

                            try {
                              await Provider.of<UserProvider>(
                                context,
                                listen: false,
                              ).saveTask(task);

                              await SendNotifcaion.sendPushNotification(
                                targetToken: selectedUser.deviceToken ?? "",
                                title: titleController.text.trim(),
                                body: descriptionController.text.trim(),
                              );

                              log("Task saved successfully ");

                              Messenger.alertSuccess(
                                "Task Assigned Successfully",
                              );

                              Navigator.pop(context);
                            } catch (e, stacktrace) {
                              log("Something went wrong: $e");
                              log("Stacktrace: $stacktrace");
                              ToastHelper.showToast(
                                message: "Something went Wrong!",
                              );
                            }
                          } else {
                            ToastHelper.showToast(
                              message: "Please fill all fields",
                            );
                          }
                        },

                        color: Colors.blue,
                        texxt: 'Assign Task',
                        width: 180,
                        height: 40,
                        txtcolor: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    vSpace8, vSpace8,
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
