import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userform/login.dart';
import 'package:userform/sharedprefences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController dateInput = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _Email = TextEditingController();

  String dropdownvalue = 'Btech';
  File? imageFile;
  String image = "";

  var items = [
    'Btech',
    'BE',
    'Mtech',
    'BSC',
    'MSC',
    'Diploma',
    'BCA',
  ];
  @override
  void initState() {
    super.initState();
    SharedPref.uidGetter().then((value) {
      print(value);
      FirebaseFirestore.instance
          .collection("User")
          .doc(value)
          .get()
          .then((val) {
        print(val.data());
        final myData = val.data() ?? {};
        if (myData.isNotEmpty) {
          print(myData["Url"]);
          _controller.text = myData["name"];
          _Email.text = myData["email"];
          dateInput.text = myData["date"];
          dropdownvalue = myData["qualification"];

          image = myData["Url"];
          setState(() {});
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(image);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit profile'),
        actions: <Widget>[
          ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const loginPage(
                              title: '',
                            )));

                Future clearSharedPref() async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text("logout")),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          CircleAvatar(
              backgroundColor: Colors.black,
              radius: 100,
              backgroundImage: imageFile != null
                  ? FileImage(imageFile!)
                  : image.isNotEmpty
                      ? NetworkImage(image) as ImageProvider
                      : const AssetImage("aseets/images/to-do-list-apps.png")),
          ElevatedButton(
            child: const Text('Update profile'),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 100,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton.icon(
                                onPressed: () {
                                  getFromGalleryandCamera(ImageSource.gallery);
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.photo_album),
                                label: const Text("Gallery")),
                            ElevatedButton.icon(
                                onPressed: () {
                                  getFromCamera(ImageSource.camera);
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.add_a_photo),
                                label: const Text("Camera")),
                          ]),
                    );
                  });
            },
          ),
          TextField(
            controller: _controller,
            decoration:
                const InputDecoration(labelText: 'Name', hintText: 'Name'),
          ),
          TextField(
            controller: _Email,
            decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Email',
                border: InputBorder.none),
          ),
          TextField(
            controller: dateInput,
            decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today), labelText: 'Enter date'),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1990),
                  lastDate: DateTime(2100));

              if (pickedDate != null) {
                print(pickedDate);

                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                print(formattedDate);

                setState(() {
                  dateInput.text = formattedDate;
                });
              } else {}
            },
          ),
          DropdownButtonFormField(
              decoration: const InputDecoration(hintText: 'Qualifiction'),
              value: dropdownvalue.isNotEmpty ? dropdownvalue : null,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: items.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownvalue = newValue!;
                });
              }),
        ],
      )),
    );
  }

  getFromGalleryandCamera(ImageSource source) async {
    ImagePicker().pickImage(source: source).then((value) {
      if (value != null) {
        imageFile = File(value.path);
        setState(() {});
      } else {}
    });
  }

  getFromCamera(ImageSource source) async {
    ImagePicker().pickImage(source: source).then((value) {
      if (value != null) {
        imageFile = File(value.path);
        setState(() {});
      } else {}
    });
  }
}
