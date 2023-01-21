import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:scanner/screens/login.dart';
import 'package:scanner/screens/update.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = new TextEditingController();
  String _scanBarcode = 'Unknown';
  String? name;

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print("naveen  ======== > "+barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if(barcodeScanRes == "-1"){
        barcodeScanRes =" ";
      }
      print("latest   ======== > "+barcodeScanRes);
      searchController.text = '';
      _scanBarcode = barcodeScanRes;
      searchController.text = _scanBarcode;
    });
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      searchController.text = (_scanBarcode != -1) ? '' : _scanBarcode;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getdetails();
    super.initState();
  }

  getdetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("firstName");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: const Text(
              'Home',
              /*  style: TextStyle(
                  fontSize: 40,
                ), */
            ),
            centerTitle: true,
            actions: [
              IconButton(
                  // iconSize: 40,
                  onPressed: () => scanQR(),
                  icon: const Icon(Icons.qr_code_scanner)),
              IconButton(
                  // iconSize: 40,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  icon: const Icon(Icons.logout))
            ]),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 100, right: 100, bottom: 30),
              child: Column(
                children: [
                  Text("Welcome $name",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22)),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: searchController,
                    style: const TextStyle(color: Colors.black),
                    maxLines: 1,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintStyle: const TextStyle(color: Colors.black),
                      hintText: 'Search Text',
                      prefixIcon: const Icon(Icons.search, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
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
                    child: const Text(
                      'Search',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateList(
                            patientIddata: searchController.text,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            /* Expanded(
                child: ListView.builder(
                  itemCount: 70,
                  itemBuilder: (context, index) {
                    return const Card(
                      child: ListTile(
                        focusColor: Colors.blue,
                        hoverColor: Colors.yellow,
                        textColor: Colors.black,
                        tileColor: Colors.white,
                        trailing: Text("View"),
                        title: Text("24/09/2022"),
                        subtitle: Text("name"),
                      ),
                    );
                  },
                ),
              ), */
          ],
        ),
      ),
    );
  }
}
