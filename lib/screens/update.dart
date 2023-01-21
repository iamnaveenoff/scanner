import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path/path.dart';
import 'package:scanner/screens/attached_images.dart';
import 'package:scanner/screens/home.dart';
import 'package:scanner/screens/login.dart';

class UpdateList extends StatefulWidget {
  final String patientIddata;
  UpdateList({Key? key, required this.patientIddata}) : super(key: key);

  @override
  State<UpdateList> createState() => _UpdateListState();
}

class _UpdateListState extends State<UpdateList> {
  void imagePickerOption() {
    Get.bottomSheet(
      SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: Container(
            color: Colors.white,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Pic Image From",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text("CAMERA"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("GALLERY"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.close),
                    label: const Text("CANCEL"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  final _picker = ImagePicker();
  bool showSpinner = true;
  bool attachmentAvailability = false;
  File? selectedImage;
  TextEditingController patientIdData = TextEditingController();
  TextEditingController patientNameData = TextEditingController();
  TextEditingController regNoData = TextEditingController();
  TextEditingController mobileNoData = TextEditingController();
  TextEditingController genderData = TextEditingController();
  TextEditingController dobData = TextEditingController();
  String? patnid;
  late String patientId;
  late String patientName;
  late String regNo;
  late String mobileNo;
  late String gender;
  late String dob;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getdetails();
  }

  getdetails() async {
    final String url =
        'http://106.51.1.103/hmsapi/LoginApi/GetPatientDetails?ids=${widget.patientIddata}';
    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
    });
    if (response.statusCode == 200) {
      var convertDataJson = json.decode(response.body);
      var datajson = convertDataJson['myRoot'];
      if (datajson.length == 0) {
        print('no data');
        ErrorAlert(this.context);
      } else if (datajson.length != 0) {
        patientId = datajson[0]['PatnId'].toString();
        regNo = datajson[0]['RegNo'];
        patientName = datajson[0]['PatnName'];
        gender = datajson[0]['Gender'];
        mobileNo = datajson[0]['MobileNo'];
        dob = datajson[0]['DOB'];
      }
      print("get details = $datajson");
      setState(() {
        showSpinner = false;
      });
    } else {
      throw Exception('Failed to load data from Server.');
    }

    patientIdData.text = patientId;
    patientNameData.text = patientName;
    regNoData.text = regNo;
    genderData.text = gender;
    mobileNoData.text = mobileNo;
    dobData.text = dob;

    final String attachmenturl =
        'http://106.51.1.103/hmsapi/loginapi/GetPatientList?ids=${widget.patientIddata}';
    var attchmentResponse = await http.get(Uri.parse(attachmenturl), headers: {
      "Content-Type": "application/json",
    });
    if (attchmentResponse.statusCode == 200) {
      var convertDataJsons = json.decode(attchmentResponse.body);
      var datajsons = convertDataJsons['myRoot'];
      if (datajsons.length == 0) {
        print('no attachment');
      } else if (datajsons.length != 0) {
        setState(() {
          attachmentAvailability = true;
        });
      }
      print("attachments Details = $datajsons");
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
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Message"),
      content: const Text('There is no data for provided ID'),
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
    return SafeArea(
      child: ModalProgressHUD(
        progressIndicator: const SizedBox(
          height: 150.0,
          width: 150.0,
          child: CircularProgressIndicator(
            strokeWidth: 5,
            backgroundColor: Colors.greenAccent,
          ),
        ),
        color: Colors.black,
        opacity: 0.70,
        inAsyncCall: showSpinner,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              title: const Text(
                "Patient Details",
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
              ]),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: patientIdData,
                    readOnly: true,
                    style: const TextStyle(color: Colors.black),
                    maxLines: 1,
                    decoration: InputDecoration(
                      fillColor: Colors.grey[300],
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintStyle: const TextStyle(color: Colors.black),
                      hintText: 'Patient ID',
                      prefixIcon: const Icon(Icons.card_membership,
                          color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: patientNameData,
                    readOnly: true,
                    style: const TextStyle(color: Colors.black),
                    maxLines: 1,
                    decoration: InputDecoration(
                      fillColor: Colors.grey[300],
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintStyle: const TextStyle(color: Colors.black),
                      hintText: 'Patient Name',
                      prefixIcon: const Icon(Icons.person, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: regNoData,
                    readOnly: true,
                    style: const TextStyle(color: Colors.black),
                    maxLines: 1,
                    decoration: InputDecoration(
                      fillColor: Colors.grey[300],
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintStyle: const TextStyle(color: Colors.black),
                      hintText: 'Register No',
                      prefixIcon: const Icon(Icons.pin, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: mobileNoData,
                    readOnly: true,
                    style: const TextStyle(color: Colors.black),
                    maxLines: 1,
                    decoration: InputDecoration(
                      fillColor: Colors.grey[300],
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintStyle: const TextStyle(color: Colors.black),
                      hintText: 'Mobile No',
                      prefixIcon: const Icon(Icons.phone, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: genderData,
                    readOnly: true,
                    style: const TextStyle(color: Colors.black),
                    maxLines: 1,
                    decoration: InputDecoration(
                      fillColor: Colors.grey[300],
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintStyle: const TextStyle(color: Colors.black),
                      hintText: 'Gender',
                      prefixIcon: const Icon(Icons.boy, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: dobData,
                    readOnly: true,
                    style: const TextStyle(color: Colors.black),
                    maxLines: 1,
                    decoration: InputDecoration(
                      fillColor: Colors.grey[300],
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintStyle: const TextStyle(color: Colors.black),
                      hintText: 'Date',
                      prefixIcon:
                          const Icon(Icons.date_range, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (attachmentAvailability != false) ...[
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AttachedImages(
                                  patientIddata: widget.patientIddata)),
                        );
                      },
                      icon: const Icon(Icons.attach_file_rounded,
                          color: Colors.white),
                      label: const Text(
                        "Check Uploaded Images",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                  const SizedBox(
                    height: 20,
                  ),
                  if (selectedImage != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.25,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.green)),
                          child: FutureBuilder(
                            future: _getImage(context),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                  return const Text('Please wait');
                                case ConnectionState.waiting:
                                  return const Center(
                                      child: CircularProgressIndicator());
                                default:
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    return selectedImage != null
                                        ? Image.file(selectedImage!)
                                        : const Center(
                                            child: Text("Please Get the Image",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          );
                                  }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(
                    height: 20,
                  ),
                  if (selectedImage != null) ...[
                    ElevatedButton(
                      onPressed: () {
                        // print("test");
                        submitSubscription(
                            file: selectedImage,
                            filename: basename(selectedImage!.path));
                      },
                      child: const Text("Upload",
                          style: TextStyle(color: Colors.white)),
                    )
                  ]
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: imagePickerOption,
            tooltip: 'Pick Image',
            child: const Icon(Icons.add_a_photo, color: Colors.black),
          ),
        ),
      ),
    );
  }

  pickImage(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        selectedImage = tempImage;
      });

      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  //get image from camera
  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      selectedImage = File(image!.path);
    });
    //return image;
  }

  //resize the image
  Future<void> _getImage(BuildContext context) async {
    if (selectedImage != null) {
      var imageFile = selectedImage;
    }
  }

  Future<void> submitSubscription({File? file, String? filename}) async {
    setState(() {
      showSpinner = true;
    });

    ///MultiPart request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("http://106.51.1.103/hmsapi/api/docfile"),
    );
    Map<String, String> headers = {"Content-type": "multipart/form-data"};

    request.files.add(
      http.MultipartFile(
        'myfile',
        file!.readAsBytes().asStream(),
        file.lengthSync(),
        filename: filename,
      ),
    );
    request.headers.addAll(headers);
    request.fields['patnid'] = regNoData.text;

    var response = await request.send();

    if (response.statusCode == 201) {
      print('image uploaded');
      setState(() {
        showSpinner = false;
        attachmentAvailability = true;
      });
      ScaffoldMessenger.of(this.context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Image Uploaded Successfully',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      );
      selectedImage = null;
    } else {
      ScaffoldMessenger.of(this.context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error Occured Try Again',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      );
      print('failed');
      setState(() {
        showSpinner = false;
      });
    }
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }
}
