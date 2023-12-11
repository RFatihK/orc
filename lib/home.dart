import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String result = '';
  XFile? image;
  ImagePicker? _imagePicker;

  Future<void> pickImageFromGallery() async {
    XFile? pickedImage = await _imagePicker?.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
        performImageLabeling();
      });
    }
  }

  Future<void> pickImageFromCamera() async {
    XFile? takenImage = await _imagePicker?.pickImage(
      source: ImageSource.camera,
    );

    if (takenImage != null) {
      setState(() {
        image = takenImage;
        performImageLabeling();
      });
    }
  }

  performImageLabeling() async {
    final FirebaseVisionImage firebaseVisionImage =
        FirebaseVisionImage.fromFile(image!.path as File);

    final TextRecognizer recognizer = FirebaseVision.instance.textRecognizer();
    VisionText visionText = await recognizer.processImage(firebaseVisionImage);

    result = '';

    setState(() {
      for (TextBlock block in visionText.blocks) {
        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            result += "${element.text} ";
          }
        }
        result += "\n\n";
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/back.jpg'), fit: BoxFit.cover),
      ),
      child: Column(
        children: [
          const SizedBox(width: 100),
          Container(
            height: 280,
            width: 250,
            margin: const EdgeInsets.only(top: 70),
            padding: const EdgeInsets.only(left: 28, bottom: 5, right: 18),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(result,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify),
              ),
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets\note.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
              margin: const EdgeInsets.only(top: 20, right: 140),
              child: Stack(children: [
                Center(
                  child: Image.asset('assets/pin.png', height: 240, width: 240),
                )
              ])),
          Center(
            child: TextButton(
              onPressed: () {
                pickImageFromGallery();
              },
              onLongPress: () {
                pickImageFromCamera();
              },
              child: Container(
                  margin: const EdgeInsets.only(top: 25),
                  child: image != null
                      ? Image.file(
                          image as File,
                          width: 140,
                          height: 192,
                          fit: BoxFit.fill,
                        )
                      : const SizedBox(
                          width: 240,
                          height: 200,
                          child: Icon(
                            Icons.camera_enhance_sharp,
                            size: 100,
                            color: Colors.greenAccent,
                          ))),
            ),
          ),
        ],
      ),
    );
  }
}
