// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:mobile/utils/secureStorage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CreateEventForm extends StatefulWidget {
  const CreateEventForm({super.key});

  @override
  _CreateEventFormState createState() => _CreateEventFormState();
}

class _CreateEventFormState extends State<CreateEventForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _bannerController = TextEditingController();
  final TextEditingController _participantNumberController =
      TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();

  void createEvent() async {
    var dio = Dio();

    String? token = await SecureStorage.getStorageItem('token');
    dio.options.headers['Authorization'] = 'Bearer $token';

    String? apiUrl = '${dotenv.env['URL_BACK']}/event';

    try {
      var response = await dio.post(apiUrl!, data: {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'date': _dateController.text,
        'banner': _bannerController.text,
        'participant_number': int.parse(_participantNumberController.text),
        'lat': double.parse(_latController.text),
        'lng': double.parse(_lngController.text),
        'location': _locationController.text,
        'tag': _tagController.text,
        'image': _imageController.text,
        'place': _placeController.text,
      });

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Succès"),
            content: Text("Événement créé avec succès."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Erreur"),
          content: Text("Erreur lors de la création de l'événement. $e"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Créer un événement"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Titre",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: "Date (YYYY-MM-DD)",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: _bannerController,
                decoration: InputDecoration(
                  labelText: "Bannière (URL)",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: _participantNumberController,
                decoration: InputDecoration(
                  labelText: "Nombre de participants",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: _latController,
                decoration: InputDecoration(
                  labelText: "Latitude",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: _lngController,
                decoration: InputDecoration(
                  labelText: "Longitude",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: "Location",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: _tagController,
                decoration: InputDecoration(
                  labelText: "Tag",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: _imageController,
                decoration: InputDecoration(
                  labelText: "Image (URL)",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: _placeController,
                decoration: InputDecoration(
                  labelText: "Place",
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: createEvent,
              child: Text("Créer Événement"),
            ),
          ],
        ),
      ),
    );
  }
}
