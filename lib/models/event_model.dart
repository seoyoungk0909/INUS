const List EVENT_CATEGORY = ["Seminar", "Workshop", "Competition"];

class Event {
  String title = "The Inequality of Lifetime Pensions";
  String category = "Seminar";
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
