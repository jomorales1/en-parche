import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

// ignore: camel_case_types
class   newEventPage extends StatefulWidget {
  const newEventPage({super.key});

  @override
  State<newEventPage> createState() => newEventPageState();
}

// ignore: camel_case_types
class newEventPageState extends State<newEventPage> {
  // Nota: Esto es un GlobalKey<FormState>, no un GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleInput = TextEditingController();
  TextEditingController startTimeInput = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  TextEditingController placeInput = TextEditingController();
  TextEditingController organizerInput = TextEditingController();
  TextEditingController descriptionInput = TextEditingController();

  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add"),
        ),
      body: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: imageProfile(),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: titleInput,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.title),
                    hintText: 'Ingrese el titulo del evento',
                    labelText: 'Título',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty || value.contains('@')){
                      return 'Input is invalid';
                    }
                    return null;
                  },
                  autocorrect: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: startTimeInput,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.timer), //icon of text field
                      labelText: "Enter Time" //label text of field
                  ),
                  validator: (String? value) {
                    if (value == null || value == ""){
                      return 'Input is invalid';
                    }
                    return null;
                  },
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? pickedTime =  await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );
                    if(pickedTime != null ){
                      // ignore: use_build_context_synchronously
                      DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                      String formattedTime = DateFormat('HH:mm').format(parsedTime);
                      setState(() {
                        startTimeInput.text = formattedTime; //set the value of text field.
                      });
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: dateInput, //editing controller of this TextField
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.calendar_today), //icon of text field
                      labelText: "Fecha" //label text of field
                  ),
                  validator: (String? value) {
                    if (value == null || value == ""){
                      return 'Input is invalid';
                    }
                    return null;
                  },
                  readOnly: true,  //set it true, so that user will not able to edit text
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context, initialDate: DateTime.now(),
                        firstDate: DateTime.now(), // - not to allow to choose before today.
                        lastDate: DateTime(2050)
                    );
                    if(pickedDate != null ){
                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                      setState(() {
                        dateInput.text = formattedDate; //set output date to TextField value.
                      });
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: placeInput,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.place),
                    hintText: 'Ingrese el lugar del evento',
                    labelText: 'Lugar',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty || value.contains('@')){
                      return 'Input is invalid';
                    }
                    return null;
                  },
                  autocorrect: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: organizerInput,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.person_pin_outlined),
                    hintText: 'Ingrese el organizador del evento',
                    labelText: 'Organizador',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty || value.contains('@')){
                      return 'Input is invalid';
                    }
                    return null;
                  },
                  autocorrect: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: descriptionInput,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.description),
                    hintText: 'Ingrese el descripción del evento',
                    labelText: 'Descripción',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty || value.contains('@')){
                      return 'Input is invalid';
                    }
                    return null;
                  },
                  maxLines: 5,
                  autocorrect: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print(titleInput.text);
                      print(dateInput.text);
                      print(startTimeInput.text);
                      print("Validado");
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        )
      );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 80.0,
          // ignore: unnecessary_null_comparison
          backgroundImage: _imageFile == null
              ? const AssetImage("assets/images/logo.PNG") as ImageProvider
              : FileImage(File(_imageFile!.path)),
        ),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: const Icon(
              Icons.camera_alt,
              color: Colors.teal,
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: const Text("Camera"),
            ),
            TextButton.icon(
              icon: const Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: const Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile!;
    });
  }
}