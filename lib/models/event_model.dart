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
  late DateTime timestamp;

  Event({
    String? eventTitle,
    String? eventCategory,
    String? eventTag,
  }) {
    title = eventTitle ?? title;
    category = eventCategory ?? category;
    tag = eventTag ?? tag;
    timestamp = DateTime.now();
  }
}
