import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scanner/screens/gridDetails.dart';
import 'package:scanner/screens/grid_cell.dart';
import 'package:scanner/screens/login.dart';

import 'package:http/http.dart' as http;
import 'package:scanner/screens/update.dart';

class AttachedImages extends StatefulWidget {
  final String patientIddata;
  AttachedImages({Key? key, required this.patientIddata}) : super(key: key);

  @override
  State<AttachedImages> createState() => _AttachedImagesState();
}

class _AttachedImagesState extends State<AttachedImages> {
  late List<AttachedImageModel> attachmentList;

  gridView(AsyncSnapshot<List<AttachedImageModel>> snapshot) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: snapshot.data!.map((details) {
          return GestureDetector(
              child:  GridTile(child: PhotoCell(model: details,)),
              onTap: () {
                goDetailpage(details);
              });
        }).toList(),
      ),
    );
  }

  goDetailpage(AttachedImageModel details) {
   
   Navigator.push(
context,
MaterialPageRoute(
fullscreenDialog: true,
builder: (BuildContext context) => GridDetails(
curAlbum: details,
),
),
);
  }

  getdetails() async {
    final String url =
        'http://106.51.1.103/hmsapi/loginapi/GetPatientList?ids=${widget.patientIddata}';
    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
    });
    if (response.statusCode == 200) {
      var convertDataJson = json.decode(response.body);
      var datajson = convertDataJson['myRoot'];
      if (datajson.length == 0) {
        print('no data');
        ErrorAlert(context);
      } else if (datajson.length != 0) {}
      print("get details = $datajson");
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  ErrorAlert(BuildContext context) {
    Widget okButton = ElevatedButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UpdateList(
                    patientIddata: widget.patientIddata,
                  )),
        );
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Message"),
      content: const Text('There is no Attachement Available'),
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
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchDishes();
  }

  Future<List<AttachedImageModel>> fetchDishes() async {
    final String url =
        'http://106.51.1.103/hmsapi/loginapi/GetPatientList?ids=${widget.patientIddata}';

    var response = await http
        .get(Uri.parse(url), headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      var convertDataJson = json.decode(response.body);
      var datajson = convertDataJson['myRoot'];

      final items = datajson.cast<Map<String, dynamic>>();
      //print("scholarship items = $items");

      attachmentList = items.map<AttachedImageModel>((json) {
        return AttachedImageModel.fromJson(json);
      }).toList();

      print("attachmentList = $attachmentList");
      return attachmentList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: const Text(
              "Attached Images",
              // style: TextStyle(
              //   fontSize: 35,
              // ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                  // iconSize: 40,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  icon: const Icon(Icons.logout))
            ],
          ),
          /* body: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            Container(
              child: GestureDetector(
                onTap: () {},
                child: Image.network(
                  'https://images.unsplash.com/photo-1547721064-da6cfb341d50',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ), */
          body: FutureBuilder<List<AttachedImageModel>>(
              future: fetchDishes(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                attachmentList = snapshot.data!;
                return gridView(snapshot);
              })),
    );
  }
}

class AttachedImageModel {
  int? patnEId;
  int? patnId;
  String? patnImgPath;
  String? createdDate;

  AttachedImageModel(
      {this.patnEId, this.patnId, this.patnImgPath, this.createdDate});

  AttachedImageModel.fromJson(Map<String, dynamic> json) {
    patnEId = json['PatnEId'];
    patnId = json['PatnId'];
    patnImgPath = json['Patn_img_path'];
    createdDate = json['CreatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PatnEId'] = patnEId;
    data['PatnId'] = patnId;
    data['Patn_img_path'] = patnImgPath;
    data['CreatedDate'] = createdDate;
    return data;
  }
}
