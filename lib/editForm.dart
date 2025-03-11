import 'package:flutter/material.dart';

class EditForm extends StatelessWidget {
  const EditForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("할 일 수정"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _EditForm(),
    );
  }
}

class _EditForm extends StatefulWidget {
  const _EditForm({super.key});

  @override
  State<_EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<_EditForm> {
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        child: Column(
          children: <Widget>[
            Container(
              child: TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "할 일",
                  hintText: "할 일을 입력하세요.",
                ),
              ),
            ),
            Checkbox(value: false, onChanged: (value) {}),
            SizedBox(
              child: ElevatedButton(onPressed: () {}, child: Text("수정")),
            ),
          ],
        ),
      ),
    );
  }
}
