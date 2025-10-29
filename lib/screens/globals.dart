import 'package:flutter/material.dart';

// ✅ Expenses notifier
ValueNotifier<List<Map<String, dynamic>>> expensesNotifier =
    ValueNotifier<List<Map<String, dynamic>>>([]);

// ✅ Incomes notifier
ValueNotifier<List<Map<String, dynamic>>> incomesNotifier =
    ValueNotifier<List<Map<String, dynamic>>>([]);

// ✅ Profile data notifier
// Example: [{ "name": "Rabia", "email": "abc@gmail.com", "budget": 2000, "goal": 10000, "image": "path" }]
ValueNotifier<List<Map<String, dynamic>>> profileDataNotifier =
    ValueNotifier<List<Map<String, dynamic>>>([]);

// ✅ Update profile (save/update data)
void updateProfile(Map<String, dynamic> profile) {
  profileDataNotifier.value = [profile];
  profileDataNotifier.notifyListeners();
}
