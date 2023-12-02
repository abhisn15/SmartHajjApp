import 'dart:io';
import 'package:SmartHajj/BottomNavigationBar.dart';
import 'package:SmartHajj/BottomNavigationJamaah.dart';
import 'package:SmartHajj/dompet/dompetScreen.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class EditJamaahScreen extends StatefulWidget {
  final String pilgrimId;
  final String agentId;
  final Map<String, dynamic> item;

  const EditJamaahScreen(
      {Key? key,
      required this.pilgrimId,
      required this.item,
      required this.agentId})
      : super(key: key);

  @override
  _EditJamaahScreenState createState() => _EditJamaahScreenState();
}

class _EditJamaahScreenState extends State<EditJamaahScreen> {
  late Map<String, dynamic> pilgrimData;
  late String agentId;

  @override
  void initState() {
    super.initState();
    // Initialize the pilgrimData to an empty map
    pilgrimData = {};
    agentId = widget.agentId;
    // Print pilgrimId to the console
    print('Pilgrim ID: ${widget.pilgrimId}');
    print('Agent ID: ${widget.agentId}');
    // Set values to controllers from widget.item with null-aware operators
    nameController.text = widget.item['name'] ?? '';
    nikController.text = widget.item['nik'] ?? '';
    phoneNumberController.text = widget.item['phone'] ?? '';
    addressController.text = widget.item['address'] ?? '';
    cityController.text = widget.item['city'] ?? '';
    passportNoController.text = widget.item['f_passport_number'] ?? '';
    visaNoController.text = widget.item['f_visa'] ?? '';
    fatherNameController.text = widget.item['father_name'] ?? '';
    bornPlaceController.text = widget.item['born_place'] ?? '';
    placeOfBirthController.text = widget.item['born_date'] ?? '';

    // Fetch Jamaah data when the screen is initialized
  }

  File? image;
  File? kartuKeluargaImage;
  final ImagePicker _imagePicker = ImagePicker();
  String? passportFilePath;
  String? visaFilePath;
  File? passportFile;
  File? visaFile;
  DateTime? selectedDate;
  DateTime dateTime = DateTime.now();
  TextEditingController nameController = TextEditingController();
  TextEditingController photoController = TextEditingController();
  TextEditingController nikController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController familyCardController = TextEditingController();
  TextEditingController passportNoController = TextEditingController();
  TextEditingController visaNoController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController bornPlaceController = TextEditingController();
  TextEditingController placeOfBirthController = TextEditingController();

  Future pickImageFromCamera() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage == null) return;
    final imageTemp = File(pickedImage.path);
    setState(() => image = imageTemp);
  }

  Future pickImageFromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    final imageTemp = File(pickedImage.path);
    setState(() => image = imageTemp);
  }

  Future<XFile?> _pickImageFromGallery() async {
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<XFile?> _pickImageFromCamera() async {
    var image = await _imagePicker.pickImage(source: ImageSource.camera);
    return image;
  }

  Future<void> _showImageSourceDialog(bool isKartuKeluarga) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Gallery'),
                  onTap: () async {
                    Navigator.pop(context);
                    XFile? image = await _pickImageFromGallery();
                    if (isKartuKeluarga) {
                      setState(() {
                        kartuKeluargaImage =
                            image != null ? File(image.path) : null;
                        // Set value to the controller
                        familyCardController.text =
                            kartuKeluargaImage?.path ?? '';
                      });
                    } else {
                      setState(() {
                        this.image = image != null ? File(image.path) : null;
                        // Set value to the controller
                        photoController.text = this.image?.path ?? '';
                      });
                    }
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text('Camera'),
                  onTap: () async {
                    Navigator.pop(context);
                    XFile? image = await _pickImageFromCamera();
                    if (isKartuKeluarga) {
                      // ... (kode lainnya)
                    } else {
                      setState(() {
                        this.image = image != null ? File(image.path) : null;
                        // Set value to the controller
                        photoController.text = image?.path ?? '';
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<File?> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      String? filePath = result.files.single.path;
      if (filePath != null) {
        File file = File(filePath);
        return file;
      } else {
        print('File path is null');
        return null;
      }
    } else {
      print('User canceled the picker');
      return null;
    }
  }

  Future<void> _showAlert(String title, String message) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _getContentType(File? file) {
    if (file == null) {
      return 'unknown';
    }

    String extension = path.extension(file.path).toLowerCase();
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      default:
        return 'unknown';
    }
  }

  String _getContentTypeFile(File? file) {
    if (file == null) {
      return 'unknown';
    }

    String extension = path.extension(file.path).toLowerCase();
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.pdf':
        return 'application/pdf';
      case '.doc':
      case '.docx':
        return 'application/msword';
      case '.xls':
      case '.xlsx':
        return 'application/vnd.ms-excel';
      case '.ppt':
      case '.pptx':
        return 'application/vnd.ms-powerpoint';
      // Add more cases as needed for other file types
      default:
        return 'unknown';
    }
  }

  Future<void> updateJamaahData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      print(token);

      if (token == null) {
        throw Exception('Token not available');
      }

      var data = FormData();

      data.fields.add(MapEntry('agentId', agentId));
      data.fields.add(MapEntry('name', nameController.text));
      data.fields.add(MapEntry('nik', nikController.text));
      data.fields.add(MapEntry('phone', phoneNumberController.text));
      data.fields.add(MapEntry('address', addressController.text));
      data.fields.add(MapEntry('city', cityController.text));
      data.fields.add(MapEntry('father_name', fatherNameController.text));
      data.fields.add(MapEntry('born_place', bornPlaceController.text));
      data.fields.add(MapEntry('born_date', placeOfBirthController.text));

      if (image != null) {
        data.files.add(MapEntry(
          'f_pic',
          await MultipartFile.fromFile(
            image!.path,
            filename: 'photo.jpg',
            contentType: MediaType.parse(_getContentType(image)),
          ),
        ));
      }

      if (kartuKeluargaImage != null) {
        data.files.add(MapEntry(
          'f_family_card',
          await MultipartFile.fromFile(
            kartuKeluargaImage!.path,
            filename: 'kartu_keluarga.jpg',
            contentType: MediaType.parse(_getContentType(kartuKeluargaImage)),
          ),
        ));
      }

      if (passportFile != null) {
        data.files.add(MapEntry(
          'f_passport_number',
          await MultipartFile.fromFile(
            passportFile!.path,
            filename: 'passport.pdf',
            contentType: MediaType.parse(_getContentTypeFile(passportFile)),
          ),
        ));
      }

      if (visaFile != null) {
        data.files.add(MapEntry(
          'f_visa',
          await MultipartFile.fromFile(
            visaFile!.path,
            filename: 'visa.pdf',
            contentType: MediaType.parse(_getContentTypeFile(visaFile)),
          ),
        ));
      }

      print('name: ${nameController.text}');
      print('uploadPhoto: ${photoController.text}');
      print('nik: ${nikController.text}');
      print('Nomor Telepon: ${phoneNumberController.text}');
      print('alamat: ${addressController.text}');
      print('kota: ${cityController.text}');
      print('kartuKeluarga: ${familyCardController.text}');
      print('Nama Ayah: ${fatherNameController.text}');
      print('Tempat Lahir: ${bornPlaceController.text}');
      print('Tanggal Lahir: ${placeOfBirthController.text}');
      print('Passport File Path: ${passportFile?.path}');
      print('Visa File Path: ${visaFile?.path}');

      if (nameController.text.isEmpty ||
          nikController.text.isEmpty ||
          phoneNumberController.text.isEmpty ||
          addressController.text.isEmpty ||
          cityController.text.isEmpty ||
          fatherNameController.text.isEmpty ||
          bornPlaceController.text.isEmpty ||
          placeOfBirthController.text.isEmpty ||
          image == null ||
          kartuKeluargaImage == null ||
          passportFile == null ||
          visaFile == null) {
        List<String> emptyFields = [];
        if (nameController.text.isEmpty) emptyFields.add('Name');
        if (nikController.text.isEmpty) emptyFields.add('NIK');
        if (phoneNumberController.text.isEmpty) emptyFields.add('Phone Number');
        if (addressController.text.isEmpty) emptyFields.add('Address');
        if (cityController.text.isEmpty) emptyFields.add('City');
        if (fatherNameController.text.isEmpty)
          emptyFields.add('Father\'s Name');
        if (bornPlaceController.text.isEmpty) emptyFields.add('Born Place');
        if (placeOfBirthController.text.isEmpty)
          emptyFields.add('Place of Birth');
        if (image == null) emptyFields.add('Photo');
        if (kartuKeluargaImage == null) emptyFields.add('Kartu Keluarga Image');
        if (passportFile == null) emptyFields.add('Passport File');
        if (visaFile == null) emptyFields.add('Visa File');

        throw Exception(
            'Please fill in all required fields: ${emptyFields.join(', ')}');
      }

      print('uploadPhoto: ${image?.path}');
      print('Kartu Keluarga Image Path: ${kartuKeluargaImage?.path}');
      print('Passport File Path: ${passportFile?.path}');
      print('Visa File Path: ${visaFile?.path}');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Ubah Data Successfull!!"),
            content: Text("Data yang telah anda rubah berhasil!!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.pushReplacement(
                    // Navigate to login screen
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNavigationJamaah(),
                    ),
                  );
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );

      // Create Dio instance
      Dio dio = Dio();

      // Make the POST request using Dio
      var response = await dio.post(
        'https://smarthajj.coffeelabs.id/api/update/${widget.item['pilgrim_id']}',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Data saved successfully');
        _showAlert('Success', 'Data saved successfully');
      } else {
        print('Failed to save data. Status code: ${response.statusCode}');
        _showAlert('Error',
            'Failed to save data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Ubah Data Error"),
            content: Text("Ada kesalahan tunggu yaa!!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.pushReplacement(
                    // Navigate to login screen
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNavigationJamaah(),
                    ),
                  );
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      print('Error sending data: $e');
    }
  }

  FormData createFormData() {
    return FormData.fromMap({
      'agent_id': agentId,
      'name': nameController.text,
      'f_pic': MultipartFile.fromFileSync(
        image!.path,
        filename: 'photo.jpg',
        contentType: MediaType.parse(_getContentType(image)),
      ),
      'nik': nikController.text,
      'phone': phoneNumberController.text,
      'address': addressController.text,
      'city': cityController.text,
      'f_family_card': MultipartFile.fromFileSync(
        kartuKeluargaImage!.path,
        filename: 'kartu_keluarga.jpg',
        contentType: MediaType.parse(_getContentType(kartuKeluargaImage)),
      ),
      'f_passport_number': MultipartFile.fromFileSync(
        passportFile!.path,
        filename: 'passport.pdf',
        contentType: MediaType.parse(_getContentTypeFile(passportFile)),
      ),
      'f_visa': MultipartFile.fromFileSync(
        visaFile!.path,
        filename: 'visa.pdf',
        contentType: MediaType.parse(_getContentTypeFile(visaFile)),
      ),
      'father_name': fatherNameController.text,
      'born_place': bornPlaceController.text,
      'born_date': placeOfBirthController.text,
    });
  }

  void clearForm() {
    nameController.text = '';
    photoController.text = '';
    nikController.text = '';
    phoneNumberController.text = '';
    addressController.text = '';
    cityController.text = '';
    familyCardController.text = '';
    passportNoController.text = '';
    visaNoController.text = '';
    fatherNameController.text = '';
    bornPlaceController.text = '';
    placeOfBirthController.text = '';
  }

  Widget buildImagePreview(
      {File? selectedImage, bool isKartuKeluarga = false}) {
    return selectedImage != null
        ? Image.file(
            selectedImage,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          )
        : Image.network(
            isKartuKeluarga
                ? "https://smarthajj.coffeelabs.id/storage/${widget.item['f_family_card']}"
                : "https://smarthajj.coffeelabs.id/storage/${widget.item['f_pic']}", // Replace with your other placeholder image
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          );
  }

  final textField = Color.fromRGBO(244, 244, 244, 1);
  final abu = Color.fromRGBO(141, 148, 168, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Jamaah'),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 24, top: 30),
                child: Row(
                  children: [
                    Text(
                      "Nama",
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                    ),
                    Text(
                      "*",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w400,
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 16.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: textField,
                borderRadius: BorderRadius.circular(70.0),
              ),
              child: Form(
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'ex : Papa Khan',
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 18.0,
                      horizontal: 20.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 24, top: 20),
                child: Text(
                  "Upload Foto",
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: 90,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () => _showImageSourceDialog(
                    false), // Panggil pickImage langsung saat tombol ditekan
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10 * 1),
                      child: Image.asset(
                        "assets/jemaah/tambah.png",
                        height: 40,
                        width: 20,
                      ),
                    )
                  ],
                ),
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor: MaterialStateProperty.all<Color>(textField),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          70.0), // Border radius sebesar 70
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(16),
            child: buildImagePreview(selectedImage: image),
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 24, top: 20),
                child: Row(
                  children: [
                    Text(
                      "NIK",
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                    ),
                    Text(
                      "*",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 20),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 16.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: textField,
                  borderRadius: BorderRadius.circular(70.0),
                ),
                child: Form(
                  child: TextField(
                    controller: nikController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 18.0,
                        horizontal: 20.0,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 24),
                  child: Row(
                    children: [
                      Text(
                        "Nomor Telepon",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 16.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: textField,
                      borderRadius: BorderRadius.circular(70.0),
                    ),
                    child: Form(
                      child: TextField(
                        controller: phoneNumberController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 18.0,
                            horizontal: 20.0,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 24),
                  child: Row(
                    children: [
                      Text(
                        "Alamat",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 16.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: textField,
                      borderRadius: BorderRadius.circular(70.0),
                    ),
                    child: Form(
                      child: TextField(
                        controller: addressController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 18.0,
                            horizontal: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 24),
                  child: Row(
                    children: [
                      Text(
                        "Kota",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 16.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: textField,
                      borderRadius: BorderRadius.circular(70.0),
                    ),
                    child: Form(
                      child: TextField(
                        controller: cityController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 18.0,
                            horizontal: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Kartu Keluarga",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 18),
                      ),
                      Text(
                        "*Lewati jika tidak ada perubahan",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 90,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () => _showImageSourceDialog(true),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10 * 1),
                            child: Image.asset(
                              "assets/jemaah/tambah.png",
                              height: 40,
                              width: 20,
                            ),
                          )
                        ],
                      ),
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(textField),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(70.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.all(16),
                    child: buildImagePreview(
                      selectedImage: kartuKeluargaImage,
                      isKartuKeluarga: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "No Passport",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "*Lewati jika tidak ada perubahan",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 16.0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: textField,
                            borderRadius: BorderRadius.circular(70.0),
                          ),
                          child: Form(
                            child: TextField(
                              readOnly: true,
                              controller: passportNoController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 18.0,
                                  horizontal: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                              right: 10,
                            ),
                            child: IntrinsicWidth(
                              child: ElevatedButton(
                                onPressed: () async {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles();

                                  if (result != null &&
                                      result.files.isNotEmpty) {
                                    String? filePath = result.files.single.path;
                                    if (filePath != null) {
                                      File file = File(filePath);
                                      // Handle the selected file here.
                                      setState(() {
                                        passportFile = file;
                                        passportNoController.text =
                                            file.path.split('/').last;
                                        print(
                                            'Selected file (No Passport): $file');
                                        print(
                                            'Passport File Path: ${passportFile?.path}');
                                      });
                                    } else {
                                      // Handle the case where the path is null
                                      print('File path is null');
                                    }
                                  } else {
                                    // User canceled the picker
                                    print('User canceled the picker');
                                  }
                                },
                                style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Colors.transparent,
                                  ),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "+ Upload File",
                                    style: TextStyle(
                                      color: abu,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "No Visa",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    "*Lewati jika tidak ada perubahan",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 16.0,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: textField,
                                  borderRadius: BorderRadius.circular(70.0),
                                ),
                                child: Form(
                                  child: TextField(
                                    readOnly: true,
                                    controller: visaNoController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 18.0,
                                        horizontal: 20.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                    right: 10,
                                  ),
                                  child: IntrinsicWidth(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        FilePickerResult? result =
                                            await FilePicker.platform
                                                .pickFiles();

                                        if (result != null &&
                                            result.files.isNotEmpty) {
                                          String? filePath =
                                              result.files.single.path;
                                          if (filePath != null) {
                                            File file = File(filePath);
                                            // Handle the selected file here.
                                            setState(() {
                                              visaFile = file;
                                              visaNoController.text =
                                                  file.path.split('/').last;
                                              print(
                                                  'Selected file (No Visa): $file');
                                              print(
                                                  'Visa File Path: ${visaFile?.path}');
                                            });
                                          } else {
                                            // Handle the case where the path is null
                                            print('File path is null');
                                          }
                                        } else {
                                          // User canceled the picker
                                          print('User canceled the picker');
                                        }
                                      },
                                      style: ButtonStyle(
                                        elevation: MaterialStateProperty.all(0),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          Colors.transparent,
                                        ),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "+ Upload File",
                                          style: TextStyle(
                                            color: abu,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 24),
                        child: Row(
                          children: [
                            Text(
                              "Nama Ayah Kandung",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 16.0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: textField,
                            borderRadius: BorderRadius.circular(70.0),
                          ),
                          child: Form(
                            child: TextField(
                              controller: fatherNameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 18.0,
                                  horizontal: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 24),
                        child: Row(
                          children: [
                            Text(
                              "Tempat Lahir",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 16.0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: textField,
                            borderRadius: BorderRadius.circular(70.0),
                          ),
                          child: Form(
                            child: TextField(
                              controller: bornPlaceController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 18.0,
                                  horizontal: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 24, top: 20),
                      child: Text(
                        "Tanggal Lahir",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 90,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: textField,
                        borderRadius: BorderRadius.circular(70.0),
                      ),
                      child: CupertinoButton(
                        onPressed: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Scaffold(
                                  backgroundColor: Colors.transparent,
                                  body: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      width: double.infinity,
                                      height: 250,
                                      color: Colors.white,
                                      child: CupertinoDatePicker(
                                        backgroundColor: Colors.white,
                                        initialDateTime: selectedDate ??
                                            DateTime.now(), // Use selectedDate
                                        onDateTimeChanged: (DateTime newTime) {
                                          setState(() {
                                            selectedDate =
                                                newTime; // Update selectedDate
                                            // Format the date as needed (e.g., 'yyyy-MM-dd')
                                            String formattedDate =
                                                DateFormat('yyyy-MM-dd').format(
                                                    selectedDate ??
                                                        DateTime.now());
                                            // Assign the formatted date to the controller
                                            placeOfBirthController.text =
                                                formattedDate;
                                          });
                                        },
                                        use24hFormat: true,
                                        mode: CupertinoDatePickerMode.date,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${DateFormat('yyyy-MM-dd').format(selectedDate ?? (widget.item['born_date'] is DateTime ? widget.item['born_date'] : DateTime.parse(widget.item['born_date'] ?? DateTime.now().toString())))}",
                                style: TextStyle(color: abu),
                              ),
                              Image.asset(
                                "assets/jemaah/tanggalLahir.png",
                                height: 35,
                                width: 35,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, bottom: 0, top: 30),
                  child: ElevatedButton(
                    onPressed: updateJamaahData,
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(43, 69, 112, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      minimumSize: Size(350, 50),
                    ),
                    child: Text(
                      'Ubah Data',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      clearForm();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(245, 137, 77, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      minimumSize: Size(350, 50),
                    ),
                    child: Text(
                      'Hapus Data',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ])));
  }
}
