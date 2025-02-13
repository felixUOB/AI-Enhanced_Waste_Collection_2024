class JourneyRoute {
  final double distance;
  final double mpg;
  final String date;
  // indicate if it is from the database are a filler value
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