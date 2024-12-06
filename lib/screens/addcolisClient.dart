import 'dart:convert';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'map.dart';

class AddColisClient extends StatefulWidget {
  final iduser;
  const AddColisClient({super.key, required this.iduser});

  @override
  State<AddColisClient> createState() => _AddColisClientState(iduser);
}

class _AddColisClientState extends State<AddColisClient> {
  int iduser;
  _AddColisClientState(this.iduser);

  List data = [];
  List dataAccepte = [];
  List datarefuse = [];
  List dataprix = [];
  List datauser = [];
  List data2 = [];
  List naturecolis = [];
  int _selectedValueNature = 1;
  int _selectedValueTaille = 1;
  int _selectedValuetype = 1;

  String idcoli = '0';
  bool isobpassword = false;
  bool t = true;
  int currentStep = 0;
  double km = 0.0;
  String kmd = '';
  String prix = '0';
  String prixclient = '0';
  double _price = 0;
  Map datacoli = {};
  String messageetat = '';
  late LatLng _SendLocation;
  late LatLng _DestinationLocation;
  late String dateuser;
  late String timeuser;

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  TextEditingController fullnameE = TextEditingController();
  TextEditingController emailE = TextEditingController();
  TextEditingController phonenumberE = TextEditingController();
  TextEditingController placeE = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController adressedetailleE = TextEditingController();

  TextEditingController date = TextEditingController();

  TextEditingController fullnameR = TextEditingController();
  TextEditingController emailR = TextEditingController();
  TextEditingController phonenumberR = TextEditingController();
  TextEditingController placeR = TextEditingController();
  TextEditingController adressedetailleR = TextEditingController();

  TextEditingController prixc = TextEditingController();
  TextEditingController price = TextEditingController();

  Future savecoli(Map datacoli) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/colis'),
      body: {
        'iduser': datacoli['iduser'].toString(),
        'description': datacoli['description'],
        'idtaillecoli': _selectedValueTaille.toString(),
        'idtypecoli': _selectedValuetype.toString(),
        'prixbase': datacoli['prixbase'],
        'date': dateuser,
        'time': timeuser,
        'fullname': datacoli['fullnameE'],
        'email': datacoli['emailE'],
        'phonenumber': datacoli['phonenumberE'],
        'fullnamer': datacoli['fullnameR'],
        'emailr': datacoli['emailR'],
        'phonenumberr': datacoli['phonenumberR'],
        'adresse': datacoli['placeE'],
        'longitude': _SendLocation.longitude.toString(),
        'latitude': _SendLocation.latitude.toString(),
        'adresser': datacoli['placeR'],
        'longituder': _DestinationLocation.longitude.toString(),
        'latituder': _DestinationLocation.latitude.toString(),
        'idnature': _selectedValueNature.toString(),
      },
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);

      setState(() {
        data.add(ok);
      });
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return (12742 * asin(sqrt(a)));
  }

  String CalculePrix(km) {
    return prix = (0.5 * km).toString();
  }

  Future updatePrix(idcoli, prixclient) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/updatePrix'),
      body: {'idcoli': idcoli.toString(), 'prixclient': prixclient.toString()},
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      setState(() {
        dataprix.add(ok);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Ajouter un Coli',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Container(
        color: Colors.black12,
        child: Stepper(
          type: StepperType.vertical,
          steps: getSteps(),
          currentStep: currentStep,
          onStepContinue: () async {
            if (currentStep == 3) {
              if (!_formKey.currentState!.validate()) {
                return null;
              }
            }

            if (currentStep == 4) {
              if (!_formKey2.currentState!.validate()) {
                return null;
              }
            }
            if (currentStep == 5) {
              if (date.text.isEmpty || date.text == null) {
                return null;
              }
            }
            if (currentStep == 6) {
              if (description.text.isEmpty) {
                return null;
              }
            }

            if (currentStep == 7) {
              if (placeE.text.isEmpty && placeR.text.isEmpty) {
                return null;
              } else {
                km = calculateDistance(
                    _SendLocation.latitude,
                    _SendLocation.longitude,
                    _DestinationLocation.latitude,
                    _DestinationLocation.longitude);

                prix = CalculePrix(km.round());
                prixclient = double.parse(prix).round().toString();
                if (double.parse(prix).round() <= 3) {
                  setState(() {
                    prix = '3';
                    prixclient = '3';
                  });
                } else {
                  setState(() {
                    prix = double.parse(prix).round().toString();
                  });
                }
                _price = double.parse(prix);

                datacoli = {
                  'iduser': iduser.toString(),
                  'fullnameE': fullnameE.text,
                  'emailE': emailE.text,
                  'phonenumberE': phonenumberE.text,
                  'placeE': '${placeE.text} | ${adressedetailleE.text}',
                  'fullnameR': fullnameR.text,
                  'emailR': emailR.text,
                  'phonenumberR': phonenumberR.text,
                  'placeR': '${placeR.text} | ${adressedetailleR.text}',
                  'description': description.text,
                  'idnature': _selectedValueNature,
                  'prixbase': prix,
                };

                await savecoli(datacoli);

                if (data.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 1),
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
                            "Problem de sauvegardé la Coli ! ",
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
                  idcoli = data[0]['idcoli'].toString();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 2),
                      content: Container(
                        padding: EdgeInsets.all(16),
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                "Coli Sauvegarder dans brouillon ",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                "Merci du confirmé votre prix !",
                                style: TextStyle(
                                  fontSize: 19,
                                  color: Colors.blue,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                  );
                  Future.delayed(Duration(seconds: 2), () {
                    setState(() {
                      currentStep += 1;
                    });
                  });
                }
              }
            } else {
              setState(() {
                currentStep += 1;
              });
            }
          },
          onStepCancel: () {
            setState(() => currentStep -= 1);
          },
          controlsBuilder: (context, details) {
            final _is6Step = currentStep == getSteps().length - 2;

            return Container(
              margin: const EdgeInsets.only(top: 50),
              child: Row(
                children: [
                  if (currentStep != 8)
                    Expanded(
                      child: ElevatedButton(
                          child: Text(_is6Step ? 'Enregistrer' : 'Suivant'),
                          onPressed: details.onStepContinue),
                    ),
                  const SizedBox(
                    width: 12,
                  ),
                  if (currentStep != 0)
                    Expanded(
                      child: ElevatedButton(
                          child: Text('Retour'),
                          onPressed: details.onStepCancel),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Step> getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep == 0,
          title: Text('Nature de Coli'),
          content: Column(
            children: [
              RadioListTile(
                title: Text('Alimentaire'),
                value: 1,
                groupValue: _selectedValueNature,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) {
                  setState(() {
                    _selectedValueNature = value!;
                  });
                },
              ),
              RadioListTile(
                title: Text('Electronique'),
                groupValue: _selectedValueNature,
                value: 2,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) {
                  setState(() {
                    _selectedValueNature = value!;
                  });
                },
              ),
              RadioListTile(
                title: Text('Vetement'),
                groupValue: _selectedValueNature,
                value: 3,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) {
                  setState(() {
                    _selectedValueNature = value!;
                  });
                },
              ),
            ],
          ),
        ),
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep == 1,
          title: Text('Type De Coli'),
          content: Column(
            children: [
              RadioListTile(
                title: Text('Coli Normale'),
                value: 1,
                groupValue: _selectedValuetype,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) {
                  setState(() {
                    _selectedValuetype = value!;
                  });
                },
              ),
              RadioListTile(
                title: Text('Coli Urgente'),
                value: 2,
                groupValue: _selectedValuetype,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) {
                  setState(() {
                    _selectedValuetype = value!;
                  });
                },
              ),
            ],
          ),
        ),
        Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep == 2,
          title: Text('Taille De Coli'),
          content: Column(
            children: [
              RadioListTile(
                title: Text('Petite (< 10 kg)'),
                value: 1,
                groupValue: _selectedValueTaille,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) {
                  setState(() {
                    _selectedValueTaille = value!;
                  });
                },
              ),
              RadioListTile(
                title: Text('Moyenne (10 kg vers 20 kg)'),
                groupValue: _selectedValueTaille,
                value: 2,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) {
                  setState(() {
                    _selectedValueTaille = value!;
                  });
                },
              ),
              RadioListTile(
                title: Text('Grande (30 kg)'),
                groupValue: _selectedValueTaille,
                value: 3,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) {
                  setState(() {
                    _selectedValueTaille = value!;
                  });
                },
              ),
            ],
          ),
        ),
        Step(
          state: currentStep > 3 ? StepState.complete : StepState.indexed,
          isActive: currentStep == 3,
          title: Text("Information d'envoyeur"),
          content: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est Obligatoire.';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.name,
                  controller: fullnameE,
                  decoration: InputDecoration(
                    labelText: 'Full name',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est Obligatoire.';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  controller: emailE,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est Obligatoire.';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.phone,
                  controller: phonenumberE,
                  maxLength: 8,
                  decoration: InputDecoration(
                    labelText: 'Phone number',
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est Obligatoire.';
                    } else {
                      return null;
                    }
                  },
                  readOnly: true,
                  controller: placeE,
                  decoration: InputDecoration(
                    hintText: 'Cliquer pour positionné ICI -->',
                    suffixIcon: IconButton(
                      onPressed: () async {
                        LatLng location = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Map1(),
                          ),
                        );
                        _SendLocation = location;
                        List<Placemark> placemarks =
                            await placemarkFromCoordinates(
                                location.latitude, location.longitude);
                        placeE.text =
                            '${placemarks.first.country},${placemarks.first.street}';
                      },
                      icon: Icon(Icons.maps_home_work),
                    ),
                    prefixIcon: Icon(Icons.map_outlined),
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est Obligatoire.';
                    } else {
                      return null;
                    }
                  },
                  controller: adressedetailleE,
                  decoration: InputDecoration(
                    labelText: 'Adresse detaillé',
                    prefixIcon: Icon(Icons.place),
                  ),
                ),
              ],
            ),
          ),
        ),
        Step(
          state: currentStep > 4 ? StepState.complete : StepState.indexed,
          isActive: currentStep == 4,
          title: Text("Information de recepteur"),
          content: Form(
            key: _formKey2,
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est Obligatoire.';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.name,
                  controller: fullnameR,
                  decoration: InputDecoration(
                    labelText: 'Full name',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est Obligatoire.';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  controller: emailR,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est Obligatoire.';
                    } else {
                      return null;
                    }
                  },
                  maxLength: 8,
                  keyboardType: TextInputType.phone,
                  controller: phonenumberR,
                  decoration: InputDecoration(
                    labelText: 'Phone number',
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est Obligatoire.';
                    } else {
                      return null;
                    }
                  },
                  readOnly: true,
                  controller: placeR,
                  decoration: InputDecoration(
                    hintText: 'Cliquer pour positionné ICI -->',
                    suffixIcon: IconButton(
                      onPressed: () async {
                        LatLng location = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Map1(),
                            ));
                        _DestinationLocation = location;
                        List<Placemark> placemarks =
                            await placemarkFromCoordinates(
                                location.latitude, location.longitude);
                        placeR.text =
                            '${placemarks.first.country},${placemarks.first.street}';
                      },
                      icon: Icon(Icons.maps_home_work),
                    ),
                    prefixIcon: Icon(Icons.map_outlined),
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est Obligatoire.';
                    } else {
                      return null;
                    }
                  },
                  controller: adressedetailleR,
                  decoration: InputDecoration(
                    labelText: 'Adresse detaillé',
                    prefixIcon: Icon(Icons.place),
                  ),
                ),
              ],
            ),
          ),
        ),
        Step(
          state: currentStep > 5 ? StepState.complete : StepState.indexed,
          isActive: currentStep == 5,
          title: Text('Date de debut'),
          content: Column(
            children: [
              TextFormField(
                readOnly: true,
                maxLines: 2,
                controller: date,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Choisir une date et heure.. ->',
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.alarm,
                      size: 30,
                      color: Colors.black,
                    ),
                    onPressed: () async {
                      DateTime now = DateTime.now();
                      String datenow =
                          DateFormat("yyyy-MM-dd").format(DateTime.now());
                      print(datenow);

                      DateTime? userdate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(now.year, now.month, now.day + 2),
                      );
                      TimeOfDay? usertime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: now.hour,
                          minute: now.minute,
                        ),
                      );

                      if (userdate == null || usertime == null) {
                        dateuser = '${now.year}-${now.month}-${now.day}';
                        timeuser = '${now.hour}:${now.minute}';
                        setState(() {
                          date.text = 'Date : $dateuser\nHeure : $timeuser';
                        });
                      } else {
                        dateuser =
                            '${userdate.year}-${userdate.month}-${userdate.day}';
                        timeuser = '${usertime.hour}:${usertime.minute}';
                        setState(() {
                          date.text = 'Date : $dateuser\nHeure : $timeuser';
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Step(
          state: currentStep > 6 ? StepState.complete : StepState.indexed,
          isActive: currentStep == 6,
          title: Text('Description'),
          content: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ce champ est obligatoire';
                  } else {
                    return null;
                  }
                },
                controller: description,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Donner une description...',
                ),
              ),
            ],
          ),
        ),
        Step(
          state: currentStep > 7 ? StepState.complete : StepState.indexed,
          isActive: currentStep == 7,
          title: Text('Resume'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nature :\t $_selectedValueNature'),
              Text('Email Envoyeur :\t ${emailE.text}'),
              Text('Email Recepture :\t ${emailR.text}'),
              Text('type :\t $_selectedValuetype'),
              Text('Taille :\t $_selectedValueTaille'),
            ],
          ),
        ),
        Step(
          state: currentStep > 8 ? StepState.complete : StepState.indexed,
          isActive: currentStep == 8,
          title: Text('Prix'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trajet De Coli : ${km.toStringAsFixed(2)} km',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Prix par KM : 0.5 dt',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Prix Base : $prix dt',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Votre prix : $prixclient dt',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Positioned(
                left: 100,
                child: Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        color: Colors.green,
                        child: Text(
                          'Confirmer',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (km == 0) {
                            return null;
                          }
                          await updatePrix(idcoli, prixclient.toString());

                          if (dataprix[0]['succes'] == 'succes') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 1),
                                content: Container(
                                  padding: EdgeInsets.all(16),
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Colis Ajouter Avec succes',
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
                            Future.delayed(Duration(seconds: 1), () {
                              setState(() {
                                currentStep = 0;
                              });
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 1),
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
                                      "Problem d'insertion Ressayer ! ",
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
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: MaterialButton(
                        color: Colors.amber,
                        child: Text(
                          'Changer Prix',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          if (km == 0) {
                            return null;
                          }

                          price.text = prix;
                          _price = double.parse(prix);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor:
                                    Color.fromARGB(249, 252, 231, 45),
                                title: Text('Changer le prix'),
                                content: Container(
                                  height: 100,
                                  width: 350,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Max : ${((double.parse(prix) * 20 / 100) + double.parse(prix)).round()} dt',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      if (_selectedValuetype == 1)
                                        Text(
                                          'Min : ${(double.parse(prix) - (double.parse(prix) * 20 / 100)).round()} dt',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      TextFormField(
                                        controller: price,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          prefixIcon: IconButton(
                                            icon: Icon(Icons.add),
                                            onPressed: () {
                                              var percentage =
                                                  (double.parse(prix) * 20) /
                                                      100;
                                              var max = double.parse(prix) +
                                                  percentage;
                                              if (double.parse(price.text) ==
                                                  max.round()) {
                                                setState(() {});
                                                return null;
                                              } else {
                                                setState(() {
                                                  _price = _price + 1;
                                                  price.text = '$_price';
                                                });
                                                setState(() {});
                                              }
                                            },
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(Icons.remove),
                                            onPressed: () {
                                              if (_selectedValuetype == 2) {
                                                return null;
                                              }
                                              var percentage =
                                                  (double.parse(prix) * 20) /
                                                      100;
                                              var min = double.parse(prix) -
                                                  percentage;
                                              if (_selectedValuetype == 2) {
                                                min = double.parse(prix);
                                              }
                                              print(min.round());
                                              if (double.parse(price.text) ==
                                                  min.round()) {
                                                setState(() {});
                                                return null;
                                              } else {
                                                setState(
                                                  () {
                                                    _price = _price - 1;
                                                    price.text = '$_price';
                                                  },
                                                );
                                                setState(() {});
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('Confirmer'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        prixclient = price.text;
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ];
}
