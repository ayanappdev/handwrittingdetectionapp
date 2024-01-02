// import 'dart:typed_data';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart'; // For picking images from the gallery or camera
// import 'package:firebase_storage/firebase_storage.dart'; // For uploading images to Firebase Storage
// import 'package:firebase_core/firebase_core.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// void main() async {
//   try {
//     WidgetsFlutterBinding.ensureInitialized();
//     await Firebase.initializeApp(); // Initialize Firebase
//     runApp(MyApp());
//   } catch (e) {
//     debugPrint("Error initializing Firebase: $e");
//   }
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   String? text;
//   String responseText = "Press the button to fetch data";
//   String? imageUrl;

//   // // for androird

//   Future<void> uploadImage() async {
//     final ImagePicker _picker = ImagePicker();
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       Uint8List? imageData = await image.readAsBytes();
//       final FirebaseStorage storage = FirebaseStorage.instance;
//       final Reference ref = storage
//           .ref()
//           .child('uploads/${DateTime.now().toIso8601String()}_${image.name}');
//       final UploadTask uploadTask = ref.putData(
//         imageData,
//         SettableMetadata(contentType: 'image/jpeg'),
//       );
//       final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
//       final String downloadUrl = await snapshot.ref.getDownloadURL();
//       setState(() {
//         imageUrl = downloadUrl;
//         responseText = "Image uploaded! URL: $imageUrl";
//       });
//     } else {
//       setState(() {
//         responseText = 'No image selected.';
//       });
//     }
//   }
//   // for web

//   // Future<void> uploadImage() async {
//   //   FilePickerResult? result = await FilePicker.platform.pickFiles(
//   //     type: FileType.image,
//   //   );

//   //   if (result != null) {
//   //     PlatformFile file = result.files.first;
//   //     Uint8List? imageData = file.bytes;
//   //     String fileName = file.name;

//   //     final FirebaseStorage storage = FirebaseStorage.instance;
//   //     final Reference ref = storage
//   //         .ref()
//   //         .child('handwritten/${DateTime.now().toIso8601String()}_$fileName');
//   //     final UploadTask uploadTask = ref.putData(
//   //       imageData!,
//   //       SettableMetadata(contentType: 'image/jpeg'),
//   //     );
//   //     final TaskSnapshot snapshot = await uploadTask;
//   //     final String downloadUrl = await snapshot.ref.getDownloadURL();
//   //     setState(() {
//   //       imageUrl = downloadUrl;
//   //       responseText = "Image uploaded! URL: $downloadUrl";
//   //     });
//   //   } else {
//   //     setState(() {
//   //       responseText = 'No image selected.';
//   //     });
//   //   }
//   // }

//   Future<void> fetchData() async {
//     if (imageUrl == null) {
//       setState(() {
//         responseText = "No image URL available to fetch data.";
//       });
//       return;
//     }

//     final String encodedImageUrl = Uri.encodeFull(imageUrl!);

//     final String fullUrl =
//         'https://ocr-extract-text.p.rapidapi.com/ocr?url=$encodedImageUrl';
//     final Map<String, String> headers = {
//       'X-RapidAPI-Key':
//           '27326ff5bcmsha4962d1c1b1e291p1fa408jsn20a992a43bb3', // Replace with your API key
//       'X-RapidAPI-Host': 'ocr-extract-text.p.rapidapi.com',
//     };

//     try {
//       final Uri uri = Uri.parse(fullUrl);
//       final http.Response response = await http.get(uri, headers: headers);

//       if (response.statusCode == 200) {
//         final responseBody = jsonDecode(response.body);
//         text = responseBody['text'];
//         final String singleLineText = text!.replaceAll('\n', ' ');

//         setState(() {
//           responseText = singleLineText;
//         });
//       } else {
//         setState(() {
//           responseText = "Error fetching data: ${response.statusCode}";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         responseText = "Error fetching data: $e";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Container(
//           width: 350,
//           height: 450,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: Colors.grey.shade900,
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Center(
//               child: SingleChildScrollView(
//                 child: Text(
//                   responseText,
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           FloatingActionButton(
//             backgroundColor: Colors.grey.shade900,
//             onPressed: uploadImage,
//             heroTag: 'upload',
//             child: Icon(
//               Icons.file_upload,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 10),
//           FloatingActionButton(
//             backgroundColor: Colors.grey.shade900,
//             onPressed: fetchData,
//             heroTag: 'fetch',
//             child: Icon(
//               Icons.cloud_download,
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart'; // For picking images from the gallery or camera
import 'package:firebase_storage/firebase_storage.dart'; // For uploading images to Firebase Storage
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoadingimage = false;
  bool isLoadingtext = false;
  Uint8List? imageBytes;
  String responseText = "Extracted Text will show here";
  String? imageUrl;

  Future<void> uploadImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() => isLoadingimage = true); // Start loading indicator

      Uint8List imageData = await image.readAsBytes();
      final FirebaseStorage storage = FirebaseStorage.instance;
      final Reference ref = storage
          .ref()
          .child('uploads/${DateTime.now().toIso8601String()}_${image.name}');
      final UploadTask uploadTask = ref.putData(
        imageData,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});
      imageUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        imageBytes = imageData;
        isLoadingimage = false; // Stop loading indicator
      });
    } else {
      setState(() => responseText = 'No image selected.');
    }
  }

  Future<void> fetchData() async {
    if (imageUrl == null) {
      setState(() => responseText = "No image URL available to fetch data.");
      return;
    }

    setState(() => isLoadingtext = true); // Start loading indicator

    final String encodedImageUrl = Uri.encodeFull(imageUrl!);
    final String fullUrl =
        'https://ocr-extract-text.p.rapidapi.com/ocr?url=$encodedImageUrl';
    final Map<String, String> headers = {
      'X-RapidAPI-Key':
          '27326ff5bcmsha4962d1c1b1e291p1fa408jsn20a992a43bb3', // Replace with your API key
      'X-RapidAPI-Host': 'ocr-extract-text.p.rapidapi.com',
    };

    try {
      final Uri uri = Uri.parse(fullUrl);
      final http.Response response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        String text = responseBody['text'];
        String singleLineText = text.replaceAll('\n', ' ');

        setState(() {
          responseText = singleLineText;
          isLoadingtext = false; // Stop loading indicator
        });
      } else {
        setState(() {
          responseText = "Error fetching data: ${response.statusCode}";
          isLoadingtext = false; // Stop loading indicator
        });
      }
    } catch (e) {
      setState(() {
        responseText = "Error fetching data: $e";
        isLoadingtext = false; // Stop loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text(
          "Handwritting detection App",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                width: 350,
                height: 450,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade900,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: isLoadingimage
                      ? Center(
                          child: SpinKitThreeBounce(
                          color: Colors.white,
                          size: 30.0,
                        ))
                      : SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              imageBytes != null
                                  ? Image.memory(imageBytes!)
                                  : Container(),
                            ],
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 350,
                height: 450,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade900,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: isLoadingtext
                      ? Center(
                          child: SpinKitThreeBounce(
                          color: Colors.white,
                          size: 30.0,
                        ))
                      : SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              Text(
                                responseText,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: uploadImage,
            heroTag: 'upload',
            child: Icon(
              Icons.file_upload,
              color: Colors.grey.shade900,
            ),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: fetchData,
            heroTag: 'fetch',
            child: Icon(
              Icons.text_fields,
              color: Colors.grey.shade900,
            ),
          ),
        ],
      ),
    );
  }
}
