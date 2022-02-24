import 'package:fluent_ui/fluent_ui.dart';

class TestePage extends StatefulWidget {
  TestePage({Key? key}) : super(key: key);

  @override
  State<TestePage> createState() => _TestePageState();
}

class _TestePageState extends State<TestePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: TextFormBox(
        maxLines: null,
        minLines: null,
        expands: true,
      ),
    );
  }
}
