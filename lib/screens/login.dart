import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:scanner/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController id = TextEditingController();
  TextEditingController password = TextEditingController();

  late String userName;
  late String firstName;
  late String lastName;
  late String userNameData;
  late String firstNameData;
  late String lastNameData;

  getdetails() async {
    final String url =
        'http://106.51.1.103/hmsapi/LoginApi/GetLoginDetails?ids=${id.text}~${password.text}';
    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
    });
    if (response.statusCode == 200) {
      var convertDataJson = json.decode(response.body);
      var datajson = convertDataJson['myRoot'];
      if (datajson.length == 0) {
        print('no data');
        ErrorAlert(context);
      } else if (datajson.length != 0) {
        userName = datajson[0]['UserName'];
        firstName = datajson[0]['FirstName'];
        lastName = datajson[0]['LastName'];
        _savetoken(convertDataJson);
        Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
        // Navigator.pushNamed(context, '/BottomBar');
      }
      print("get details = $datajson");
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  ErrorAlert(BuildContext context) {
    Widget okButton = ElevatedButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Message"),
      content: Text('Invalid data, Check your input'),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'PHC Login',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                     style: const TextStyle(color: Colors.black),
                    controller: id,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your ID';
                      }
                      return null;
                    },
                    maxLines: 1,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      hintText: 'Enter your ID',
                      prefixIcon: const Icon(Icons.email, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    controller: password,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    maxLines: 1,
                    obscureText: true,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      prefixIcon: const Icon(Icons.lock, color: Colors.blue),
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 43, vertical: 20),
                      backgroundColor: Colors.blue,
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        getdetails();
                      }
                    },
                    
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  /* Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Not registered yet?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        child: const Text('Create an account'),
                      ),
                    ],
                  ), */
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _savetoken(convertDataJson) async {
    final prefs = await SharedPreferences.getInstance();
    userNameData = userName;
    prefs.setString('username', userNameData);
    firstNameData = firstName;
    prefs.setString('firstName', firstNameData);
    lastNameData = lastName;
    prefs.setString('lastname', lastNameData);
    return convertDataJson;
  }
}
