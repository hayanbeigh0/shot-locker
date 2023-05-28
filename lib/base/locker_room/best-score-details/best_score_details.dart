import 'dart:math';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shot_locker/utility/custom_appbar.dart';

class BestScoreDetails extends StatefulWidget {
  const BestScoreDetails({Key? key}) : super(key: key);

  @override
  _BestScoreDetailsState createState() => _BestScoreDetailsState();
}

class _BestScoreDetailsState extends State<BestScoreDetails> {
  @override
  Widget build(BuildContext context) {
    final List<GlobalKey<ExpansionTileCardState>> cardKey =
        List.generate(18, (index) => GlobalKey<ExpansionTileCardState>());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: ListView(
          children: <Widget>[
            CustomAppBar(
              centreWidget: Text(
                'My Best Score',
                style: GoogleFonts.rubik(
                  fontSize: 23.0,
                  color: Colors.white,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Column(
              children: List.generate(
                18,
                (index) => ExpansionCard(
                  cardKey: cardKey[index],
                  index: index + 1,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ExpansionCard extends StatelessWidget {
  final GlobalKey<ExpansionTileCardState> cardKey;
  final int index;

  const ExpansionCard({
    Key? key,
    required this.cardKey,
    required this.index,
  }) : super(key: key);

  DataCell _dataEntry(String value) {
    return DataCell(
      Center(
        child: Text(value),
      ),
    );
  }

  DataColumn _dataHeader(String value) {
    return DataColumn(
      label: Text(
        value,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double pgaStrokes = Random().nextDouble().ceilToDouble() * index * 21;
    double average = Random().nextDouble().ceilToDouble() * index + 28;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 12.0,
      ),
      child: ExpansionTileCard(
        key: cardKey,
        leading: CircleAvatar(child: Text('H-$index')),
        title: Row(
          children: [
            Text(
              'PGA Strokes Avg - $pgaStrokes',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
        subtitle: Row(
          //  mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Strokes Gained Avg - $average',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
        children: <Widget>[
          const Divider(thickness: 1.0, height: 1.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                _dataHeader('St. Dist'),
                _dataHeader('Surface'),
                _dataHeader('Penalty'),
                _dataHeader('PGA Strokes'),
                _dataHeader('Strokes Gained'),
              ],
              rows: [
                DataRow(cells: [
                  _dataEntry('10'),
                  _dataEntry('T'),
                  _dataEntry('0.0'),
                  _dataEntry('0.0'),
                  _dataEntry('0.0'),
                ]),
                DataRow(cells: [
                  _dataEntry('10'),
                  _dataEntry('F'),
                  _dataEntry('0.0'),
                  _dataEntry('0.0'),
                  _dataEntry('0.0'),
                ]),
                DataRow(cells: [
                  _dataEntry('10'),
                  _dataEntry('G'),
                  _dataEntry('0.0'),
                  _dataEntry('0.0'),
                  _dataEntry('0.0'),
                ]),
                DataRow(cells: [
                  _dataEntry('10'),
                  _dataEntry('R'),
                  _dataEntry('0.0'),
                  _dataEntry('0.0'),
                  _dataEntry('0.0'),
                ]),
                DataRow(cells: [
                  _dataEntry(''),
                  _dataEntry(''),
                  _dataEntry(''),
                  _dataEntry(''),
                  _dataEntry('0.0'),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
