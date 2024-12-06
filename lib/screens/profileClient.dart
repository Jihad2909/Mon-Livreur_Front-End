import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileClient extends StatefulWidget {
  final iduser;
  const ProfileClient({super.key, required this.iduser});

  @override
  State<ProfileClient> createState() => _ProfileLivreurState(iduser);
}

class _ProfileLivreurState extends State<ProfileClient> {
  int iduser;
  _ProfileLivreurState(this.iduser);

  List datauser = [];
  File? imagephotoprofile;

  final picker = ImagePicker();

  Future choicephotoprofile() async {
    var pickedimage = await picker.getImage(source: ImageSource.gallery);
    if (pickedimage == null) {
      setState(() {
        imagephotoprofile = null;
      });
    } else {
      setState(() {
        imagephotoprofile = File(pickedimage.path);
      });
    }
  }

  Future updatephoto(iduser) async {
    final uri = Uri.parse('http://10.0.2.2:8000/api/updatePhotoProfile');
    var request = http.MultipartRequest('POST', uri);
    request.fields['iduser'] = iduser.toString();

    var picphoto = await http.MultipartFile.fromPath(
        'photoprofile', imagephotoprofile!.path);
    request.files.add(picphoto);

    var response = await request.send();
    if (response.statusCode == 200) {
      print('ok');
    }
  }

  Future getuser(iduser) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/getUser'),
      body: {
        'iduser': iduser.toString(),
      },
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      setState(() {
        datauser.add(ok);
      });
    }
  }

  @override
  void initState() {
    getuser(iduser);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (datauser.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              'Votre profile',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              'Votre profile',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: Container(
          color: Colors.black12,
          padding: EdgeInsets.only(left: 15, top: 20, right: 15),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                            )
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/clientpic.jpg',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Colors.white,
                            ),
                            color: Colors.blue,
                          ),
                          child: IconButton(
                            onPressed: null,
                            /*() async {
                              await choicephotoprofile();
                              if (imagephotoprofile != null) {
                                await updatephoto(iduser);
                              }
                            },*/
                            icon: Icon(Icons.edit),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    '${datauser[0]['name']}'.toUpperCase(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                TextFormField(
                  readOnly: true,
                  initialValue: datauser[0]['email'].toString(),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      fontSize: 19,
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/upemail',
                            arguments: {'iduser': iduser.toString()},
                          );
                        },
                        icon: Icon(Icons.edit)),
                    contentPadding: EdgeInsets.only(bottom: 5),
                    labelText: 'Email',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  readOnly: true,
                  initialValue: '********',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      fontSize: 19,
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/upPassword',
                              arguments: {'id': iduser.toString()});
                        },
                        icon: Icon(Icons.edit)),
                    contentPadding: EdgeInsets.only(bottom: 5),
                    labelText: 'Password',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  readOnly: true,
                  initialValue: datauser[0]['phone'].toString(),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      fontSize: 19,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/upPhone',
                            arguments: {'iduser': iduser.toString()});
                      },
                      icon: Icon(Icons.edit),
                    ),
                    contentPadding: EdgeInsets.only(bottom: 5),
                    labelText: 'Phone Number',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 100),
                  height: 45,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 6,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  child: Expanded(
                    child: MaterialButton(
                      color: Color.fromARGB(255, 245, 196, 196),
                      child: Text(
                        'Déconnecté',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Vous ete Sur !'),
                              content: Text('déconnecté'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('oui'),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/login');
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
