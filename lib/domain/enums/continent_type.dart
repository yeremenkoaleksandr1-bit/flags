import 'package:flutter/cupertino.dart';

enum ContinentType {
  europe,
  asia,
  africa,
  oceania,
  northAmerica,
  southAmerica,
}

String createContinentTitle(ContinentType type) {
  return switch (type) {
    ContinentType.europe => "Europe",
    ContinentType.asia => "Asia",
    ContinentType.africa => "Africa",
    ContinentType.oceania => "Oceania",
    ContinentType.northAmerica => "North America",
    ContinentType.southAmerica => "South America",
  };
}

String createContinentImagePath(ContinentType type) {
  return switch (type) {
    ContinentType.europe => "assets/images/continents/europe.png",
    ContinentType.asia => "assets/images/continents/asia.png",
    ContinentType.africa => "assets/images/continents/africa.png",
    ContinentType.oceania => "assets/images/continents/oceania.png",
    ContinentType.northAmerica => "assets/images/continents/north_america.png",
    ContinentType.southAmerica => "assets/images/continents/south_america.png",
  };
}
