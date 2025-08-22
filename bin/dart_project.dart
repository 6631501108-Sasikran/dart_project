import 'package:http/http.dart' as http;
import 'dart:io';

void main() async {
  await login();
}

// Login
Future<void> login() async {
  print("===== Login =====");
  stdout.write("Username: ");
  String? username = stdin.readLineSync()?.trim();
  stdout.write("Password: ");
  String? password = stdin.readLineSync()?.trim();
  if (username == null || password == null) {
    print("Incomplete input");
    return;
  }

  final body = {"username": username, "password": password};
  final url = Uri.parse('http://localhost:3000/login');
  final response = await http.post(url, body: body);

  if (response.statusCode == 200) {
    await menuLoop(username);
  } else {
    print(response.body);
  }
}

// Menu
Future<void> menuLoop(String name) async {
  while (true) {
    print("======== Expense Tracking App ========");
    print("Welcome $name");
    print("1. All expenses");
    print("2. Today's expense");
    print("3. Search expense");
    print("4. Add new expense");
    print("5. Delete an expense");
    print("6. Exit");
    stdout.write("Choose... ");
    String? choice = stdin.readLineSync();

    if (choice == "1") {
      await showAll();
    } else if (choice == "2") {
      await showToday();
    } else if (choice == "3") {
      await searchExpense();
    } else if (choice == "4") {
      await addExpense();
    } else if (choice == "5") {
      await deleteExpense();
    } else if (choice == "6") {
      print("----- Bye -----");
      break;
    } else {
      print("No choice");
    }
    print(""); 
  }
}

// All expenses
Future<void> showAll() async {

}

// Today's expenses
Future<void> showToday() async {

}

// Search expense
Future<void> searchExpense() async {

}

// Add new expense
Future<void> addExpense() async {

}

// Delete expense
Future<void> deleteExpense() async {

}