//  vo 객체
class TodoItemVo {
  //  필드
  int id;
  String title;
  bool completed;

  //  생성자
  TodoItemVo({required this.id, required this.title, required this.completed});

  //  map(.json) => TodoItemVo 형식으로 변환 메서드
  factory TodoItemVo.fromJson(Map<String, dynamic> apiData) {
    return TodoItemVo(
      id: apiData['id'],
      title: apiData['title'],
      completed: apiData['completed'],
    );
  }
  //  현재 TodoItemVo 객체를 Map 형식으로 내보내는 메서드
  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'completed': completed};
  }
}
