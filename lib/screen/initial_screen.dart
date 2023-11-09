import 'package:canvas_labelapp/screen/canvas_screen.dart';
import 'package:flutter/material.dart';

class InitialScreen extends StatelessWidget {
  InitialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Label App'),
        centerTitle: true,
        actions: [],
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CanvasScreen(),
                    ));
              },
              child: Expanded(
                child: Container(
                  color: Colors.lightBlueAccent,
                  width: 400,
                  height: 400,
                  child: Center(
                    child: Text(
                      '라벨링하러 가기',
                      style: TextStyle(color: Colors.white, fontSize: 75.0),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print('설정 누름');
              },
              child: Expanded(
                child: Container(
                  color: Colors.lightBlueAccent,
                  width: 400,
                  height: 400,
                  child: Center(
                    child: Text(
                      '설정\n环境',
                      style: TextStyle(color: Colors.white, fontSize: 100.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
