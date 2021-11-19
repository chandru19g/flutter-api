import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List? userData;
  final String url = "https://randomuser.me/api/?results=50";
  bool isLoading = true;

  Future getData() async {
    var response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    List data = jsonDecode(response.body)['results'];

    setState(() {
      userData = data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Random Users"),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: userData == null ? 0 : userData?.length,
                itemBuilder: (BuildContext context, int index) => Card(
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(20.0),
                        child: Image(
                          width: 70.0,
                          height: 70.0,
                          fit: BoxFit.contain,
                          image: NetworkImage(
                              userData?[index]['picture']['thumbnail']),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              userData?[index]['name']['first'] +
                                  " " +
                                  userData?[index]['name']['last'],
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text("Phone: ${userData?[index]['phone']}"),
                            Text("Gender: ${userData?[index]['gender']}")
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
