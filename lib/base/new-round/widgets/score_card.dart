import 'package:flutter/material.dart';

class ScoreCard extends StatelessWidget {
  const ScoreCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(43.0),
          topRight: Radius.circular(42.0),
        ),
      ),
      child: Column(
        children: [
          // const SizedBox(height: 30.0),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 3.0,
            ),
            child: Row(
              children: [
                ClipPath(
                  clipper: MyClipper(),

                  child: Container(
                    height: 85.0,
                    width: 80.0,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          '57',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '-5',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'imrishuroy',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Castletroy',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2.0),
                    Text(
                      '17/12/2021',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 15.0),

          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 0.0),
          //   child: Column(
          //     //    crossAxisAlignment: CrossAxisAlignment.stretch,
          //     children: [
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //         children: const [
          //           HoleLabel(value: 'H'),
          //           ScoreLabel(value: 'P'),
          //           ScoreLabel(value: 'L'),
          //           ScoreLabel(value: 'S'),
          //           ScoreLabel(value: 'FW'),
          //         ],
          //       ),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //         children: const [
          //           HoleLabel(value: '1'),
          //           ScoreLabel(value: '4'),
          //           ScoreLabel(value: '312'),
          //           ScoreLabel(value: '299'),
          //           ScoreLabel(value: 'FW'),
          //         ],
          //       ),
          //     ],
          //   ),
          // )
          SizedBox(
            height: (_deviceSize.height * 0.57),
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  child: Table(
                    //textDirection: TextDirection.rtl,
                    // defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                    // border:TableBorder.all(width: 2.0,color: Colors.red),
                    children: const [
                      TableRow(
                        children: [
                          HoleLabel(value: 'H'),
                          ScoreLabel(value: 'P'),
                          ScoreLabel(value: 'D'),
                          ScoreLabel(value: 'P'),
                          ScoreLabel(value: 'SG'),
                        ],
                      ),
                      TableRow(children: [
                        HoleLabel(value: '1'),
                        ScoreLabel(value: '4'),
                        ScoreLabel(value: '50'),
                        ScoreLabel(value: '7'),
                        ScoreLabel(value: '100'),
                      ]),
                      TableRow(children: [
                        HoleLabel(value: '2'),
                        ScoreLabel(value: '2'),
                        ScoreLabel(value: '100'),
                        ScoreLabel(value: '6'),
                        ScoreLabel(value: '20'),
                      ]),
                      TableRow(children: [
                        HoleLabel(value: '3'),
                        ScoreLabel(value: '5'),
                        ScoreLabel(value: '400'),
                        ScoreLabel(value: '7'),
                        ScoreLabel(value: '10'),
                      ]),
                      TableRow(children: [
                        HoleLabel(value: '4'),
                        ScoreLabel(value: '2'),
                        ScoreLabel(value: '100'),
                        ScoreLabel(value: '6'),
                        ScoreLabel(value: '20'),
                      ]),
                      TableRow(children: [
                        HoleLabel(value: '5'),
                        ScoreLabel(value: '5'),
                        ScoreLabel(value: '400'),
                        ScoreLabel(value: '7'),
                        ScoreLabel(value: '10'),
                      ]),
                      TableRow(children: [
                        HoleLabel(value: '6'),
                        ScoreLabel(value: '2'),
                        ScoreLabel(value: '100'),
                        ScoreLabel(value: '6'),
                        ScoreLabel(value: '20'),
                      ]),
                      TableRow(children: [
                        HoleLabel(value: '7'),
                        ScoreLabel(value: '5'),
                        ScoreLabel(value: '400'),
                        ScoreLabel(value: '7'),
                        ScoreLabel(value: '10'),
                      ]),
                      TableRow(children: [
                        HoleLabel(value: '8'),
                        ScoreLabel(value: '2'),
                        ScoreLabel(value: '100'),
                        ScoreLabel(value: '6'),
                        ScoreLabel(value: '20'),
                      ]),
                      TableRow(children: [
                        HoleLabel(value: '9'),
                        ScoreLabel(value: '5'),
                        ScoreLabel(value: '400'),
                        ScoreLabel(value: '7'),
                        ScoreLabel(value: '10'),
                      ]),
                      TableRow(children: [
                        HoleLabel(value: '10'),
                        ScoreLabel(value: '2'),
                        ScoreLabel(value: '100'),
                        ScoreLabel(value: '6'),
                        ScoreLabel(value: '20'),
                      ]),
                      TableRow(children: [
                        HoleLabel(value: '11'),
                        ScoreLabel(value: '5'),
                        ScoreLabel(value: '400'),
                        ScoreLabel(value: '7'),
                        ScoreLabel(value: '10'),
                      ]),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class HoleLabel extends StatelessWidget {
  final String value;

  const HoleLabel({Key? key, required this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade800,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Center(
          child: Text(
            value,
            textScaleFactor: 1.2,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      // decoration: const BoxDecoration(

      //   // borderRadius: BorderRadius.only(
      //   //   topLeft: Radius.circular(10.0),
      //   //   topRight: Radius.circular(10.0),
      //   // ),
      // ),
      // child: const Padding(
      //   padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      //   child: SizedBox(
      //     height: 17.0,
      //     width: 50.0,
      //     child: Center(child: Text('H')),
      //   ),
      // ),
    );
  }
}

class ScoreLabel extends StatelessWidget {
  final String value;

  const ScoreLabel({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        value,
        textScaleFactor: 1.2,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );

    // Padding(
    //   padding: const EdgeInsets.symmetric(
    //     horizontal: 8.0,
    //     //vertical: 5.0,
    //   ),
    //   child: SizedBox(
    //     height: 17.0,
    //     width: 50.0,
    //     child: Center(child: Text(value)),
    //   ),
    // );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.8);
    path.lineTo(size.width * 0.8, size.height);
    path.lineTo(size.width * 0.2, size.height);
    path.lineTo(0, size.height * 0.8);
    path.lineTo(0, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
