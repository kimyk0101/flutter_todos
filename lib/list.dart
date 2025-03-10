import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_todos/todoItemVo.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("할 일 목록"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(color: Colors.grey[100], child: _ListPage()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //  Todo: 작성 폼으로 이동
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class _ListPage extends StatefulWidget {
  const _ListPage({super.key});

  @override
  State<_ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<_ListPage> {
  //  상태 정의
  //  late: 선언 시 할당하지 않고, 나중에 할당되는 변수
  late Future<List<TodoItemVo>> todoListFuture;

  //  상태 초기화: 처음 단 한번 발생
  // @override
  // void initState() {
  //   super.initState();
  // }

  //  의존성이 변경될 때
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    todoListFuture = getTodoList(); //  서버로부터 데이터 수신
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: todoListFuture, // 감시할 future 객체
      builder: (context, snapshot) {
        print("snapshot: $snapshot");

        //  상태 정보 체크
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("데이터를 불러오는데 실패했습니다: ${snapshot.error}"));
        } else if (!snapshot.hasData) {
          return Center(child: Text("할 일이 없습니다."));
        } else {
          // return Center(child: Text("데이터 수신 성공!"));
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              // return Text("${snapshot.data![index].title}");
              return Card(
                child: ListTile(
                  tileColor:
                      snapshot.data![index].completed
                          ? Colors.lightGreenAccent
                          : Colors.white,
                  leading: Checkbox(
                    value: snapshot.data![index].completed,
                    onChanged: (bool? value) {
                      //  Todo: 서버로 완료 여부 전송(PUT)
                      setState(() {
                        snapshot.data![index].completed = value ?? false;
                      });
                    },
                  ),
                  title: Text(
                    snapshot.data![index].title,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          //  Todo: 수정 폼으로 이동
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          //  Todo: 수정 폼으로 이동, 서버로 DELETE api 호출
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  //  서버로부터 TodoItem 목록을 받아오는 통신 메서드
  Future<List<TodoItemVo>> getTodoList() async {
    try {
      //  요청
      var dio = new Dio(); //  Dio 인스턴스

      //  헤더 설정: 데이터를 json 형식으로 주고 받겠다는 약속
      dio.options.headers['Content-Type'] = "application/json";

      //  서버로 목록 요청
      final response = await dio.get("http://43.201.46.192:18088/api/todos");

      //  응답
      if (response.statusCode == 200) {
        //  성공
        //  데이터 확인
        print(response.data); //  json list
        print(response.data.length); //  json list 아이템 항목 수
        print(response.data[0]); //  첫 번째 아이템

        //  결과 변수
        List<TodoItemVo> todoList = [];

        for (int i = 0; i < response.data.length; i++) {
          //  개별 아이템 받아오기
          TodoItemVo todoItem = TodoItemVo.fromJson(response.data[i]);

          //  목록에 추가
          todoList.add(todoItem);
        }

        return todoList;
      } else {
        throw Exception("api 서버 오류");
      }
    } catch (e) {
      throw Exception("할 일 목록을 불러오는데 실패했습니다: $e");
    }
  }
}
