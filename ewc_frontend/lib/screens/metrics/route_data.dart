// ignore_for_file: dangling_library_doc_comments

/// This file contains the class `JourneyRoute` which is used to store the metrics data.

class JourneyRoute {
  final double distance;
  final double mpg;
  final String date;
  // indicate if it is from the database or a filler value
  final bool filler;

  JourneyRoute(
    {
      required this.distance, 
      required this.mpg,
      required this.date,
      required this.filler,
      }
  );
}