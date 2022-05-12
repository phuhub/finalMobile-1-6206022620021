import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';

main() {
  runApp(const ShowInf());
}

class ShowInf extends StatefulWidget {
  const ShowInf({Key? key}) : super(key: key);

  @override
  State<ShowInf> createState() => _ShowInfState();
}

class _ShowInfState extends State<ShowInf> {
  List list = [];
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _createdAtController = TextEditingController();

  Future<String> listData() async {
    var response = await http.get(Uri.http('10.0.2.2:9999', 'emp'),
        headers: {"Accept": "application/json"});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    setState(() {
      list = jsonDecode(response.body);
    });
    return "Success";
  }

  @override
  void initState() {
    super.initState();
    listData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("balance_6206022620021"),
      ),
      body: Center(
        child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  title: Row(
                    children: [
                      Expanded(child: Text(list[index]["type"])),
                      Expanded(child: Text(list[index]["description"])),
                      Expanded(child: Text(list[index]["amount"])),
                      Expanded(child: Text(list[index]["createdAt"])),
                      Expanded(child: Text(list[index]["amount"])),
                    ],
                  ),
                  leading: Text(list[index]["id"].toString()),
                  trailing: Wrap(
                    spacing: 5,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.green),
                        onPressed: () {
                          Map data = {
                            'id': list[index]['id'],
                            'type': list[index]["type"],
                            'description': list[index]['description'],
                            'amount': list[index]['amount'],
                            'createdAt': list[index]['createdAt'],
                          };
                          _showedit(data);
                        },
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _showDel(list[index]["id"]),
                      ),
                    ],
                  ),
                ),
              
              );
              
            }),
            

      ),
      
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _addNewDialog();
        },
      ),
    );
  }

  Future<void> _addNewDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _typeController,
                  decoration: const InputDecoration(
                      hintText: "Enter emp type", labelText: 'type:'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                      hintText: "Enter emp description", labelText: 'description:'),
                ),
                TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                      hintText: "Enter emp amount", labelText: 'amount:'),
                ),
                const Text('กรอกข้อมูลให้เรียบร้อยแล้วกด ยืนยัน'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ยืนยัน'),
              onPressed: () {
                add_data();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDel(int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ลบข้อมูล ${id}'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('ยืนยันการลบข้อมูล กด ยืนยัน'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ยืนยัน'),
              onPressed: () {
                del_data(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void add_data() async {
    Map data = {
      'type': _typeController.text,
      'description': _descriptionController.text,
      'amount': _amountController.text,
      'createdAt': _createdAtController.text,
    };
    var body = jsonEncode(data);
    var response = await http.post(
      Uri.http('10.0.2.2:9999', 'create'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: body,
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    listData();
  }

  void del_data(int id) async {
    var response = await http.delete(Uri.http('10.0.2.2:9999', 'delete/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Accept": "application/json"
        });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    listData();
  }

  Future<void> _showedit(Map data) async {
    _typeController.text = data['type'];
    _descriptionController.text = data['description'];
    _amountController.text = data['amount'];
    _createdAtController.text = data['createdAt'];
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ทดสอบการ Edit'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _typeController,
                  decoration: const InputDecoration(
                      hintText: "Enter emp type", labelText: 'type:'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                      hintText: "Enter emp description", labelText: 'description:'),
                ),
                TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                      hintText: "Enter emp amount", labelText: 'amount:'),
                ),
                TextField(
                  controller: _createdAtController,
                  decoration: const InputDecoration(
                      hintText: "Enter emp createdAt", labelText: 'createdAt:'),
                ),
                const Text('ปรับปรุงข้อมูลให้เรียบร้อยแล้วกด ยืนยัน'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ยืนยัน'),
              onPressed: () {
                edit_data(data['id']);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void edit_data(id) async {
    Map data = {
      'type': _typeController.text,
      'description': _descriptionController.text,
      'amount': _amountController.text,
      'createdAt': _createdAtController.text,
    };
    var body = jsonEncode(data);
    var response = await http.put(
      Uri.http('10.0.2.2:9999', 'update/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    listData();
  }
}
