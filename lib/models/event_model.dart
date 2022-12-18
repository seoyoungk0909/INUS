const List eventCategory = ["Seminar", "Workshop", "Competition"];
const String seminarColor = "#56bed2";
const String competitionColor = "#ef8632";
const String workshopColor = "#4ca98f";

const double seminarButtonWidth = 50;
const double workshopButtonWidth = 58;
const double competitionButtonWidth = 68;

class Event {
  String title = "The Inequality of Lifetime Pensions";
  String category = "Seminar";
  String categoryColor = seminarColor;
  double buttonWidth = seminarButtonWidth;
  String tag = "#environment #education";
  String date = "12.01.2022";

  Event(
      {String? eventTitle,
      String? eventCategory,
      String? eventCategoryColor,
      double? eventButtonWidth,
      String? eventTag,
      String? uploadDate}) {
    title = eventTitle ?? title;
    category = eventCategory ?? category;
    categoryColor = eventCategoryColor ?? categoryColor;
    buttonWidth = eventButtonWidth ?? buttonWidth;
    tag = eventTag ?? tag;
    date = uploadDate ?? date;
  }
}
