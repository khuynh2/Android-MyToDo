class ToDoList {
  static const COLLECTION = 'todoList';
  static const EMAIL = 'email';
  static const TITLE = 'title';
  static const NOTE = 'NOTE';
  static const DUE_DATE = 'dueDate';
  static const TAGS = 'tags';
  static const COMPLETE = 'complte';

  String userId;
  String email;
  String title;
  String note;
  DateTime dueDate;
  List<dynamic> tags;
  bool complete;

  ToDoList({
    this.userId,
    this.email,
    this.title,
    this.note,
    this.dueDate,
    this.tags,
    this.complete,
  });

  //map todolist dart to fb
  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      EMAIL: email,
      TITLE: title,
      NOTE: note,
      DUE_DATE: dueDate,
      TAGS: tags,
      COMPLETE: complete,
    };
  }

  static ToDoList deserialize(Map<String, dynamic> data, String docId) {
    return ToDoList(
      userId: docId,
      email: data[ToDoList.EMAIL],
      title: data[ToDoList.TITLE],
      note: data[ToDoList.NOTE],
      dueDate: data[ToDoList.DUE_DATE],
      tags: data[ToDoList.TAGS],
      complete: data[ToDoList.COMPLETE],
    );
  }
}
