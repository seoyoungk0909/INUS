const List eventCategory = ["Seminar", "Workshop", "Competition"];

class Event {
  String title = "The Inequality of Lifetime Pensions";
  String category = "Seminar";
  String tag = "#environment #education";
  String date = "12.01.2022";

  Event(
      {String? eventTitle,
      String? eventCategory,
      String? eventTag,
      String? uploadDate}) {
    title = eventTitle ?? title;
    category = eventCategory ?? category;
    tag = eventTag ?? tag;
    date = uploadDate ?? date;
  }
}
