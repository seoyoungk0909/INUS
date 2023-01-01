const List EVENT_CATEGORY = [
  "Event",
  "Seminar",
  "Workshop",
  "Competition",
  "Webinar",
  "Party"
];

class Event {
  String title = "Tissue-engineering Integrated";
  String category = "Event";
  String tag = "#environment #education";
  String description =
      "Since their first direct discovery in 2015, gravitational waves have contributed significantly to knowledge about astrophysics and fundamental physics. This talk will first introduce the Open... ";
  String language = "English, Cantonese";
  String location =
      "IAS4042, 4/F, Lo Ka Chung Building, Lee Shau Kee Campus, HKUST";
  String date = "14 Dec 2022";
  String time = "15:40";
  late DateTime timestamp;

  Event({
    String? eventTitle,
    String? eventCategory,
    String? eventTag,
    String? eventDescription,
    String? eventLanguage,
    String? eventLocation,
    String? eventDate,
    String? eventTime,
  }) {
    title = eventTitle ?? title;
    category = eventCategory ?? category;
    tag = eventTag ?? tag;
    description = eventDescription ?? description;
    language = eventLanguage ?? language;
    location = eventLocation ?? location;
    date = eventDate ?? date;
    time = eventTime ?? time;

    timestamp = DateTime.now();
  }
}
