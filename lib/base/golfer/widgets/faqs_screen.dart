import 'package:flutter/material.dart';
import 'package:shot_locker/utility/back_ground_theme.dart';

class FAQsScreen extends StatefulWidget {
  static const routeName = 'faqs_screen';

  const FAQsScreen({Key? key}) : super(key: key);

  @override
  State<FAQsScreen> createState() => _FAQsScreenState();
}

class _FAQsScreenState extends State<FAQsScreen> {
  // final pdfController = PdfController(
  //   document: PdfDocument.openAsset(faqs),
  //   initialPage: 0,
  // );

  // @override
  // void dispose() {
  //   pdfController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    const faq1 =
        'Q. What is Shot locker?\n A. Shot locker is strokes gained golf improvement app designed for golfers of all levels with the goal to improve the way they play.';
    const faq2 =
        'Q. How does it work?\n A. A player can input their shot data during or after a round. Shot locker will then help calculate the strokes gained or lost in each category. This helps the user pinpoint specific areas for improvement while also outlining positive aspects of their game.';
    const faq3 =
        'Q. What can I compare my stats against?\n A. Depending on your level or goal, the user can compare their data against different benchmarks. The Benchmarks initially are PGA tour average. However, we plan to introduce the following in later versions: 15 Handicap, 10 Handicap, 5 Handicap, 0 Handicap.';
    const faq4 =
        'If Jane plays off a handicap of 14 but has the desire to playoff 10. Jane can compare her data to see what areas of her game need improvement to reach her desired standard. Over time, trends appear and can diagnose problem areas that are wasting strokes.';
    const faq5 =
        'Q: What do the letters Mean?\n T - Tee\n F - Fairway\n R - Rough\n S - Sand G - Green\n X - Recovery\n P - Penalty';
    const faq6 =
        'Q. How do I input a round?\n A. Select "+ New Round". Select date course and tee. Starting distance will be pre-populated but can be amended if required. Input your distance after each shot. Select the surface for each shot or if there was a penalty incurred. Once selected click on the > or next button. Once all data is complete, hit save. It’s as easy as that!';
    const faq7 =
        'Hole data should look something like this:\n T: 380\n F: 155\n S: 12\n G: 6 (green distance recorded in feet)';
    const faq8 =
        'Q. How do interpret my stats? Where do I start?\nA. The "Locker room" is where your round statistics are displayed. You have the option to select a round or a number of rounds to see how you performed across all categories. The Statistics are split among 4 key areas. Driving, Approach Play, Short Game and Putting. There is a further breakdown within these categories and you can see whether you are gaining or losing strokes in that bracket.';
    const faq9 =
        'For example:\nPlayer A gains +1.2 strokes in Approach play.\n225+ yards: +0.20\n175 - 224 yards: +0.5\n125 + 174 yards: -0.3\n75 - 124 yards: +0.8\nTotal: +1.2';
    const faq10 =
        'Q. What are the features?\nA. Locker Room: This is the homepage where Strokes Gained data is displayed. Range: Drills to aid game improvement are located here. E.g. If a player is losing strokes on Short Putting < 5 feet - they can view a drill in this section to help improve this area. New Round - this is where the User inputs round data. Explore - Twitter /Social Media Feed keeping you up to date on all things Shot locker! Golfer - Player’s profile.';
    const faq11 =
        'Q. Is my golf course in the database?\nA. Shot locker has over X number of courses worldwide. Geolocation can pick up courses nearby. If Course distances have been updated, you can manually amend. Default unit of measurement in yards but can be changed to Meters. If your course is not included you can manually input and save in favorites for next time!';
    const _paragraphList = [
      faq1,
      faq2,
      faq3,
      faq4,
      faq5,
      faq6,
      faq7,
      faq8,
      faq9,
      faq10,
      faq11,
    ];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('FAQs'),
        backgroundColor: Colors.transparent,
      ),
      body: ShotLockerBackgroundTheme(
        // child:
        // PdfView(
        //   controller: pdfController,
        //   scrollDirection: Axis.vertical,
        // ),
        child: ListView.builder(
          itemCount: _paragraphList.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              _paragraphList[index],
            ),
          ),
        ),
      ),
    );
  }
}
