import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employe_task/model/task_model.dart';
import 'package:flutter/material.dart';
import '../../model/user_model.dart';

class UserProvider extends ChangeNotifier {
  List<UserModel> users = [];
  bool isLoading = false;

  Future<void> fetchUsersByType(String userType) async {
    isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection("users")
              .where("userType", isEqualTo: userType)
              .get();

      users =
          snapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return UserModel(
              id: doc.id,
              name: data['name'] ?? '',
              contact: data['contact'] ?? '',
              monbileno: data['mobileno'] ?? '',
              password: data['password'] ?? '',
              userType: data['userType'] ?? '',
              deviceToken: data['deviceToken'],
            );
          }).toList();

      log("Fetched Users: ${users.length}");
    } catch (e) {
      log("Error fetching users: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<TaskModel> tasks = [];

  /// Fetch tasks from Firebase
  Future<void> fetchTasks(String userId) async {
    isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('tasks')
              .where('recivedId', isEqualTo: userId)
              .get();

      tasks =
          snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return TaskModel.fromJson(data);
          }).toList();

      log("Fetched ${tasks.length} tasks");
    } catch (e) {
      log("Error fetching tasks: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Save task to Firebase
  Future<void> saveTask(TaskModel task) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').add(task.toJson());
      log("Task saved successfully");
    } catch (e) {
      log("Error saving task: $e");
    }
  }
}
