import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class LivreurInfoNull extends StatefulWidget {
  const LivreurInfoNull({super.key});

  @override
  State<LivreurInfoNull> createState() => _LivreurInfoState();
}

class _LivreurInfoState extends State<LivreurInfoNull> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final namelivreur = args['namelivreur'];

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.all(10),
            width: double.infinity,
            height: 240,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 234, 232, 232),
              border: Border.all(width: 2),
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                  offset: Offset(1, 1),
                ),
              ],
            ),
            child: Column(
              children: [
                Center(
                  child: CircleAvatar(
                    maxRadius: 80,
                    backgroundImage: AssetImage(
                      'assets/images/livreurmo.jpg',
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '$namelivreur'.toUpperCase(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 234, 232, 232),
                border: Border.all(width: 2),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 6,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(width: 3),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                size: 30,
                                Icons.check_box,
                                color: Colors.green,
                              ),
                              Text(
                                '0',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            children: [
                              Icon(
                                size: 30,
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                              Text(
                                '0',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Avis : ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '0/5',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(width: 2),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: RatingBarIndicator(
                              rating: 0,
                              itemSize: 45,
                              unratedColor: Colors.grey,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 35),
                    width: double.infinity,
                    child: Text(
                      "Ce Livreur n'a pas fait encore une livraison.",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 129, 48, 42),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
