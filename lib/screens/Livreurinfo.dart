import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class LivreurInfo extends StatefulWidget {
  const LivreurInfo({super.key});

  @override
  State<LivreurInfo> createState() => _LivreurInfoState();
}

class _LivreurInfoState extends State<LivreurInfo> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final namelivreur = args['namelivreur'];
    final etoile = args['avis'];
    final nbavis = args['nbavis'];
    final nameclient = args['nameclient'];
    final messageclient = args['message'];
    final colislivrer = args['colislivrer'];
    final colisrejeter = args['colisrejeter'];
    final photo = args['photo'];
    double star = etoile / nbavis;

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
                                '$colislivrer',
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
                                '$colisrejeter',
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
                              '${star.toStringAsFixed(1)}/5',
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
                              rating: star,
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
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Avis de dernier client :',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            border: Border.all(width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    maxRadius: 20,
                                    backgroundImage: AssetImage(
                                      'assets/images/clientpic.jpg',
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '$nameclient :',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 21,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 50),
                                child: Text(
                                  '- $messageclient',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 21,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
