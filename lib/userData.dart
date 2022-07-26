import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:userform/api.dart';
import 'package:userform/login.dart';

class UserData extends StatefulWidget {
  final String id;
  final String email;

  const UserData({Key? key, required this.id, required this.email})
      : super(key: key);

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateInput = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _Email = TextEditingController();
  final TextEditingController _image = TextEditingController();

  String text = '';
  String dropdownvalue = 'Btech';
  File? imageFile;

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
    _Email.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User data')),
      body: SingleChildScrollView(
        child: Column(children: [
          Text("sdfghjk",style: TextStyle(fontWeight: FontWeight.bold)),
          CircleAvatar(
              backgroundColor: Colors.black,
              radius: 100,
              backgroundImage:
                  imageFile != null ? FileImage(imageFile!) : null),
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
          TextFormField(
            controller: _controller,
              decoration:
                const InputDecoration(labelText: 'Name *', hintText: 'Name '),
            validator: (String? value) {
              return (value != null && value.contains('@'))
                  ? 'Do not use the @ char.'
                  : null;
            },
            
          
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

              //  value: dropdownvalue,

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
          ElevatedButton(
            onPressed: () {
              print(_controller.text);
              print(_Email.text);
              print(dateInput.text);

              print(dropdownvalue);
              print(imageFile);

              print(widget.id);

              ApiService.uploadFile("images/", imageFile!).then((value) {
                if(UserData==null){

                }else{
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const loginPage(
                                title: '',
                              )));
                }
                FirebaseFirestore.instance
                    .collection("User")
                    .doc(widget.id)
                    .set({
                  "name": _controller.text,
                  "email": _Email.text,
                  "date": dateInput.text,
                  "qualification": dropdownvalue,
                  "Url": value
                });
              });
            },
            child: const Text('Submit'),
          )
        ]),
      ),
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
