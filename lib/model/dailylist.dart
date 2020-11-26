class DailyList {
  static const COLLECTION = 'dailyList';
  static const EMAIL = 'email';
  static const TITLE = 'title';
  static const NOTE = 'NOTE';
  static const WEEKDAY = 'weekDay';
  static const STREAK = 'streak';

  String userId;
  String email;
  String title;
  String note;
  List<dynamic> weekDay;
  int streak;

  DailyList({
    this.userId,
    this.email,
    this.title,
    this.note,
    this.weekDay,
    this.streak,
  });

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      EMAIL: email,
      TITLE: title,
      NOTE: note,
      WEEKDAY: weekDay,
      STREAK: streak,
    };
  }

  static DailyList deserialize(Map<String, dynamic> data, String docId) {
    return DailyList(
      userId: docId,
      email: data[DailyList.EMAIL],
      title: data[DailyList.TITLE],
      note: data[DailyList.NOTE],
      weekDay: data[DailyList.WEEKDAY],
      streak: data[DailyList.STREAK],
    );
  }
}
