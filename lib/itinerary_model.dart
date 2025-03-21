import 'dart:convert';

class Itinerary {
  final String title;
  final List<LodgingOption> lodgingOptions;
  final List<DayPlan> days;
  final List<String> budgetFriendlyTips;

  Itinerary({
    required this.title,
    required this.lodgingOptions,
    required this.days,
    required this.budgetFriendlyTips,
  });

  factory Itinerary.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);

    return Itinerary(
      title: json['title'],
      lodgingOptions: (json['lodgingOptions'] as List)
          .map((item) => LodgingOption.fromJson(item))
          .toList(),
      days: (json['days'] as List).map((item) => DayPlan.fromJson(item)).toList(),
      budgetFriendlyTips: List<String>.from(json['budgetFriendlyTips']),
    );
  }
}

class LodgingOption {
  final String hotelName;
  final String price;
  final String link;

  LodgingOption({required this.hotelName, required this.price, required this.link});

  factory LodgingOption.fromJson(Map<String, dynamic> json) {
    return LodgingOption(
      hotelName: json['hotelName'],
      price: json['price'],
      link: json['link'],
    );
  }
}

class DayPlan {
  final int dayNumber;
  final String title;
  final String morning;
  final String afternoon;
  final String evening;
  final DinnerRecommendation dinnerRecommendation;

  DayPlan({
    required this.dayNumber,
    required this.title,
    required this.morning,
    required this.afternoon,
    required this.evening,
    required this.dinnerRecommendation,
  });

  factory DayPlan.fromJson(Map<String, dynamic> json) {
    return DayPlan(
      dayNumber: json['dayNumber'],
      title: json['title'],
      morning: json['morning'],
      afternoon: json['afternoon'],
      evening: json['evening'],
      dinnerRecommendation: DinnerRecommendation.fromJson(json['dinnerRecommendation']),
    );
  }
}

class DinnerRecommendation {
  final String restaurantName;
  final String cuisine;
  final String link;

  DinnerRecommendation({
    required this.restaurantName,
    required this.cuisine,
    required this.link,
  });

  factory DinnerRecommendation.fromJson(Map<String, dynamic> json) {
    return DinnerRecommendation(
      restaurantName: json['restaurantName'],
      cuisine: json['cuisine'],
      link: json['link'],
    );
  }
}
 