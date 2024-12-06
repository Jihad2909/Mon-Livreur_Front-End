import 'dart:convert' show jsonDecode;
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monlivreur/screens/map.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class LivreurRegister extends StatefulWidget {
  const LivreurRegister({Key? key}) : super(key: key);

  @override
  _Register2PageState createState() => _Register2PageState();
}

class _Register2PageState extends State<LivreurRegister> {
  TextEditingController fullname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController place = TextEditingController();
  TextEditingController adresse = TextEditingController();
  TextEditingController selectcontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final controller = PageController();
  int pageindex = 0;
  bool isLastPage = false;
  bool _isLoading = false;
  bool register = false;
  List data = [];
  Map livreurdata = {};
  late LatLng _selectedLocation;

  File? imageserie;
  File? imagepermis;
  File? imagepiece;
  File? imagematricule;
  File? imagecartegrise;
  File? imagejustification;

  final picker = ImagePicker();

  String _valuechnaged = '';

  bool _showFormMoto = false;
  bool _showFormVoiture = false;

  Future choiceImagepermis() async {
    var pickedimage = await picker.getImage(source: ImageSource.gallery);
    if (pickedimage == null) {
      setState(() {
        imagepermis = null;
      });
    } else {
      setState(() {
        imagepermis = File(pickedimage.path);
      });
    }
  }

  Future choiceImageserie() async {
    var pickedimage = await picker.getImage(source: ImageSource.gallery);
    if (pickedimage == null) {
      setState(() {
        imageserie = null;
      });
    } else {
      setState(() {
        imageserie = File(pickedimage.path);
      });
    }
  }

  Future choiceImagepiece() async {
    var pickedimage = await picker.getImage(source: ImageSource.gallery);
    if (pickedimage == null) {
      setState(() {
        imagepiece = null;
      });
    } else {
      setState(() {
        imagepiece = File(pickedimage.path);
      });
    }
  }

  Future choiceImagematricule() async {
    var pickedimage = await picker.getImage(source: ImageSource.gallery);
    if (pickedimage == null) {
      setState(() {
        imagematricule = null;
      });
    } else {
      setState(() {
        imagematricule = File(pickedimage.path);
      });
    }
  }

  Future choiceImagecartegrise() async {
    var pickedimage = await picker.getImage(source: ImageSource.gallery);
    if (pickedimage == null) {
      setState(() {
        imagecartegrise = null;
      });
    } else {
      setState(() {
        imagecartegrise = File(pickedimage.path);
      });
    }
  }

  Future choiceImagejustification() async {
    var pickedimage = await picker.getImage(source: ImageSource.gallery);
    if (pickedimage == null) {
      setState(() {
        imagejustification = null;
      });
    } else {
      setState(() {
        imagejustification = File(pickedimage.path);
      });
    }
  }

  Future registerVoiture(Map livreurdata) async {
    final uri = Uri.parse('http://10.0.2.2:8000/api/register');
    var request = http.MultipartRequest('POST', uri);
    request.fields['fullname'] = livreurdata['fullname'];
    request.fields['email'] = livreurdata['email'];
    request.fields['password'] = livreurdata['password'];
    request.fields['place'] = livreurdata['place'];
    request.fields['idphone'] = livreurdata['idphone'].toString();
    request.fields['longitude'] = livreurdata['longitude'].toString();
    request.fields['latitude'] = livreurdata['latitude'].toString();
    request.fields['idusertype'] = '2';

    var picpermis =
        await http.MultipartFile.fromPath('permis', imagepermis!.path);
    request.files.add(picpermis);
    var picpiece =
        await http.MultipartFile.fromPath('pieceidentite', imagepiece!.path);
    request.files.add(picpiece);
    var picmat =
        await http.MultipartFile.fromPath('matricule', imagematricule!.path);
    request.files.add(picmat);
    var picCarte =
        await http.MultipartFile.fromPath('cartegrise', imagecartegrise!.path);
    request.files.add(picCarte);
    var picjustification = await http.MultipartFile.fromPath(
        'justificationAdresse', imagejustification!.path);
    request.files.add(picjustification);

    var response = await request.send();
    if (response.statusCode == 200) {
      setState(() {
        register = true;
      });
    } else {
      setState(() {
        register = false;
      });
    }
  }

  Future regiterMoto(Map livreurdata) async {
    final uri = Uri.parse('http://10.0.2.2:8000/api/register');
    var request = http.MultipartRequest('POST', uri);
    request.fields['fullname'] = livreurdata['fullname'];
    request.fields['email'] = livreurdata['email'];
    request.fields['password'] = livreurdata['password'];
    request.fields['place'] = livreurdata['place'];
    request.fields['idphone'] = livreurdata['idphone'].toString();
    request.fields['longitude'] = livreurdata['longitude'].toString();
    request.fields['latitude'] = livreurdata['latitude'].toString();
    request.fields['idusertype'] = '2';

    var picpermis =
        await http.MultipartFile.fromPath('permis', imagepermis!.path);
    request.files.add(picpermis);
    var picserie = await http.MultipartFile.fromPath('serie', imageserie!.path);
    request.files.add(picserie);
    var picpiece =
        await http.MultipartFile.fromPath('pieceidentite', imagepiece!.path);
    request.files.add(picpiece);
    var picjustification = await http.MultipartFile.fromPath(
        'justificationAdresse', imagejustification!.path);
    request.files.add(picjustification);

    var response = await request.send();
    if (response.statusCode == 200) {
      print('ok');
    } else {
      print('non');
    }
  }

  final List<Map<String, dynamic>> _items = [
    {
      'value': 'voiture',
      'label': 'Voiture',
      'icon': Icon(Iconsax.car),
      'textStyle': TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
    },
    {
      'value': 'moto',
      'label': 'Moto',
      'icon': Icon(Icons.motorcycle),
      'textStyle': TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final idphone = args['idphone'];

    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 255, 237, 183),
        padding: const EdgeInsets.only(bottom: 60),
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              pageindex = index;
            });
            setState(() => isLastPage = index == 2);
          },
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 110,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'must enter a value';
                          } else {
                            return null;
                          }
                        },
                        controller: fullname,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(20.0),
                          labelText: 'Nom et prenom',
                          hintText: 'Nom et prenom',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0,
                          ),
                          prefixIcon: Icon(
                            Iconsax.user,
                            color: Colors.black,
                            size: 18,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          floatingLabelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.5),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'must enter a value';
                          } else {
                            return null;
                          }
                        },
                        controller: email,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(20.0),
                          labelText: 'Email',
                          hintText: 'E-mail',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0,
                          ),
                          prefixIcon: Icon(
                            Icons.mail,
                            color: Colors.black,
                            size: 18,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          floatingLabelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.5),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'must enter a value';
                          } else {
                            return null;
                          }
                        },
                        controller: password,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(20.0),
                          labelText: 'Mot de passe',
                          hintText: 'Mot de passe',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0,
                          ),
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon: Icon(
                            Iconsax.key,
                            color: Colors.black,
                            size: 18,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          floatingLabelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.5),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'must enter a value';
                          } else {
                            return null;
                          }
                        },
                        controller: place,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(20.0),
                          hintText: 'Votre place sur map',
                          suffixIcon: IconButton(
                              onPressed: () async {
                                LatLng location = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Map1(),
                                    ));
                                _selectedLocation = location;
                                List<Placemark> placemarks =
                                    await placemarkFromCoordinates(
                                        location.latitude, location.longitude);
                                place.text =
                                    '${placemarks.first.country},${placemarks.first.street}';
                              },
                              icon: Icon(
                                Icons.map,
                                color: Colors.green,
                              )),
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                          prefixIcon: Icon(
                            Iconsax.location,
                            color: Colors.black,
                            size: 18,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          floatingLabelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.5),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'must enter a value';
                          } else {
                            return null;
                          }
                        },
                        controller: adresse,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(20.0),
                          hintText: 'Adresse Exacte',
                          label: Text('Adresse Exacte'),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0,
                          ),
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon: Icon(
                            Iconsax.location,
                            color: Colors.black,
                            size: 18,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          floatingLabelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.5),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      onTap: () {
                        choiceImagepermis();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 245, 191, 27),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          border: Border.all(width: 1),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        width: 320,
                        height: 190,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.all(15),
                              child: Text(
                                'Vos permis'.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 84, 82, 76),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (imagepermis == null)
                              Container(
                                width: double.infinity,
                                height: 135,
                                child: Image.asset('assets/images/permis.png'),
                              ),
                            if (imagepermis != null)
                              Container(
                                width: double.infinity,
                                height: 130,
                                child: Image.file(imagepermis!),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        choiceImagepiece();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 245, 191, 27),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          border: Border.all(width: 1),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        width: 320,
                        height: 190,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.all(15),
                              child: Text(
                                "votre Piece d'identité".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 84, 82, 76),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (imagepiece == null)
                              Container(
                                width: double.infinity,
                                height: 135,
                                child: Image.asset('assets/images/permis.png'),
                              ),
                            if (imagepiece != null)
                              Container(
                                width: double.infinity,
                                height: 130,
                                child: Image.file(imagepiece!),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        choiceImagejustification();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 245, 191, 27),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          border: Border.all(width: 1),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        width: 320,
                        height: 190,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.only(top: 15),
                              child: Text(
                                "votre justificatif domicile".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 84, 82, 76),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (imagejustification == null)
                              Container(
                                width: double.infinity,
                                height: 135,
                                child: Image.asset('assets/images/permis.png'),
                              ),
                            if (imagejustification != null)
                              Container(
                                width: double.infinity,
                                height: 130,
                                child: Image.file(imagejustification!),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: SelectFormField(
                    type: SelectFormFieldType.dropdown,
                    labelText: 'Choisir une Vehicule'.toUpperCase(),
                    icon: Icon(
                      Iconsax.car,
                      color: Colors.black,
                    ),
                    items: _items,
                    onSaved: (val) => print(val),
                    onChanged: (val) {
                      setState(() {
                        _valuechnaged = val;
                      });
                      if (_valuechnaged == 'moto') {
                        setState(() {
                          _showFormMoto = true;
                          _showFormVoiture = false;
                        });
                      } else {
                        setState(() {
                          _showFormVoiture = true;
                          _showFormMoto = false;
                        });
                      }
                    },
                  ),
                ),
                SizedBox(height: 20),
                Visibility(
                  visible: _showFormMoto,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              choiceImageserie();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/permis.png'),
                                ),
                                color: Color.fromARGB(255, 245, 191, 27),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                border: Border.all(width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 10,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                              width: 320,
                              height: 190,
                              child: Container(
                                alignment: Alignment.topCenter,
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  "Numéro de serie ".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 84, 82, 76),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _showFormVoiture,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              choiceImagematricule();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/permis.png'),
                                ),
                                color: Color.fromARGB(255, 245, 191, 27),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                border: Border.all(width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 10,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                              width: 320,
                              height: 190,
                              child: Container(
                                alignment: Alignment.topCenter,
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  "Matricule ".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 84, 82, 76),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              choiceImagecartegrise();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/permis.png'),
                                ),
                                color: Color.fromARGB(255, 245, 191, 27),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                border: Border.all(width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 10,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                              width: 320,
                              height: 190,
                              child: Container(
                                alignment: Alignment.topCenter,
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  "Carte grise".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 84, 82, 76),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? Container(
              child: MaterialButton(
                minWidth: double.infinity,
                onPressed: () async {
                  if (_valuechnaged == 'voiture') {
                    if (imagematricule == null || imagecartegrise == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 1),
                          content: Container(
                              padding: EdgeInsets.all(16),
                              height: 90,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Center(
                                  child: Text(
                                "Matricule et carte grise oubligatoire ",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ))),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        ),
                      );
                    } else {
                      setState(() {
                        _isLoading = true;
                      });
                      livreurdata = {
                        'latitude': _selectedLocation.latitude,
                        'longitude': _selectedLocation.longitude,
                        'fullname': fullname.text,
                        'email': email.text,
                        'password': password.text,
                        'place': '${place.text}|${adresse.text}',
                        'idphone': idphone,
                      };
                      await registerVoiture(livreurdata);
                      Future.delayed(Duration(seconds: 3), () {
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.pushNamed(context, '/login');
                      });
                    }
                  } else if (_valuechnaged == 'moto') {
                    if (imageserie == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 1),
                          content: Container(
                              padding: EdgeInsets.all(16),
                              height: 90,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Center(
                                  child: Text(
                                "Numéro de serie oubligatoire ",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ))),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        ),
                      );
                    } else {
                      setState(() {
                        _isLoading = true;
                      });
                      livreurdata = {
                        'latitude': _selectedLocation.latitude,
                        'longitude': _selectedLocation.longitude,
                        'fullname': fullname.text,
                        'email': email.text,
                        'password': password.text,
                        'place': '${place.text}|${adresse.text}',
                        'idphone': idphone,
                      };
                      await regiterMoto(livreurdata);
                      Future.delayed(Duration(seconds: 3), () {
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.pushNamed(context, '/login');
                      });
                    }
                  }
                },
                height: 60,
                color: Color.fromARGB(255, 247, 216, 122),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                child: _isLoading
                    ? Container(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          color: Colors.black,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        "s'inscrire".toUpperCase(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 185, 89, 0),
                        ),
                      ),
              ),
            )
          : Container(
              color: Color.fromARGB(255, 247, 216, 122),
              padding: const EdgeInsets.symmetric(horizontal: 2),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      if (pageindex == 0) {
                        if (_formkey.currentState!.validate()) {
                          controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          return null;
                        }
                      }
                      if (pageindex == 1) {
                        if (imagepermis == null ||
                            imagepiece == null ||
                            imagejustification == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: Duration(seconds: 2),
                              content: Container(
                                padding: EdgeInsets.all(16),
                                height: 90,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "vous devez inserer tous vous document !",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ),
                          );
                        } else {
                          controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        border: Border.all(
                          width: 2,
                          color: Color.fromARGB(255, 185, 89, 0),
                        ),
                      ),
                      child: Text(
                        'Suivant',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 185, 89, 0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
