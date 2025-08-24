import 'package:http/http.dart' as http;
import 'dart:convert';
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
  final url = Uri.parse('http://localhost:3000/expenses');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final body = utf8.decode(response.bodyBytes);
    final List<dynamic> expenses = jsonDecode(body);
    print("------------- All expenses -----------");
    int total = 0;

    for (var e in expenses) {
      String title = e['item'] ?? "No title";
      int amount = (e['paid'] is int) ? e['paid'] : (e['paid'] as num).toInt();
      String created = e['date'] ?? "No date";
      print("$title : $amount฿ : $created");
      total += amount;
    }
    print("Total expenses = $total฿");
  } else {
    print("Error fetching expenses: ${response.statusCode}");
  }
}

Future<void> showToday() async {
  final url = Uri.parse('http://localhost:3000/expenses/today');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> expenses = jsonDecode(response.body);
    print("------------- Today's expenses -----------");
    int total = 0;
    for (var e in expenses) {
      String title = e['item'] ?? "No title";
      int amount = (e['paid'] is int)
          ? e['paid']
          : int.tryParse(e['paid'].toString()) ?? 0;
      String created = e['date'] ?? "No date";
      print("$title : $amount฿ : $created");
      total += amount;
    }
    print("Total expenses = $total฿");
  } else {
    print("Error fetching today's expenses");
  }
}

// Search expense
Future<void> searchExpense() async {
  stdout.write("Item to search: ");
  final q = stdin.readLineSync()?.trim() ?? "";
  if (q.isEmpty) {
    print("No keyword");
    return;
  }
  final res = await http.get(Uri.parse('http://localhost:3000/expenses/search?keyword=${Uri.encodeComponent(q)}'));
  if (res.statusCode != 200) {
    print(res.body);
    return;
  }
  final data = jsonDecode(res.body);
  if (data is List && data.isNotEmpty) {
    for (final e in data) {
      final id = e['id'] ?? '';
      final item = e['item'] ?? e['name'] ?? '';
      final amount = (e['amount'] ?? e['price'] ?? 0).toString();
      final created = e['created_at'] ?? e['createdAt'] ?? '';
      final amt = amount.endsWith('.0') ? amount.substring(0, amount.length - 2) : amount;
      print("$id. $item : ${amt}฿ : $created");
    }
    return;
  }
  print('No item found');
  stdout.write("Add new expense? (y/n): ");
  final ans = stdin.readLineSync()?.trim().toLowerCase();
  if (ans != 'y') return;
  stdout.write("Item name: ");
  final name = stdin.readLineSync()?.trim() ?? "";
  stdout.write("Amount (฿): ");
  final amtStr = stdin.readLineSync()?.trim() ?? "0";
  final amt = double.tryParse(amtStr) ?? 0;
  final addRes = await http.post(Uri.parse('http://localhost:3000/expenses'), body: {
    'item': name,
    'amount': amt.toString(),
  });
  if (addRes.statusCode == 200 || addRes.statusCode == 201) {
    print("Added");
  } else {
    print(addRes.body);
  }
}

// Add new expense
Future<void> addExpense() async {
  print("===== Add new item =====");
  stdout.write("Item: ");
  final item = stdin.readLineSync()?.trim() ?? "";
  stdout.write("Paid: ");
  final paidStr = stdin.readLineSync()?.trim() ?? "";
  final paid = double.tryParse(paidStr) ?? -1;

  if (item.isEmpty || paid <= 0) {
    print("Invalid input");
    return;
  }

  final res = await http.post(
    Uri.parse('http://localhost:3000/expenses'),
    body: {
      'item': item,
      'paid': paid.toString(), // ใช้ชื่อ field paid ให้ตรงกับ DB
    },
  );

  if (res.statusCode == 200 || res.statusCode == 201) {
    print("Inserted!");
  } else {
    print(res.body.isNotEmpty ? res.body : "Insert failed");
  }
}

// Delete expense
Future<void> deleteExpense() async {
  stdout.write("Enter item id to delete: ");
  String? id = stdin.readLineSync()?.trim();
  if (id == null || id.isEmpty) {
    print("No id entered");
    return;
  }

  final url = Uri.parse('http://localhost:3000/expenses/$id');
  final response = await http.delete(url);

  if (response.statusCode == 200) {
    print("Deleted!");
  } else {
    print("Error: ${response.body}");
  }

}

