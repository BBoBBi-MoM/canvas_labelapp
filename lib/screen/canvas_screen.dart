import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CanvasScreen extends StatefulWidget {
  @override
  _CanvasScreenState createState() => _CanvasScreenState();
}

class _CanvasScreenState extends State<CanvasScreen> {
  String? imagePath;
  GlobalKey _imageKey = GlobalKey();
  List<Offset> _drawnPoints = [];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
        _drawnPoints.clear(); // 이미지 변경 시 그린 선 초기화
      });
    }
  }

  void _handleImageDragUpdate(DragUpdateDetails details) {
    RenderBox imageBox =
        _imageKey.currentContext!.findRenderObject() as RenderBox;
    Offset imageLocalPosition = imageBox.globalToLocal(details.globalPosition);

    // 원하는 속도로 좌표 업데이트
    double updateRate = 1.0;
    double updatedX = imageLocalPosition.dx * updateRate;
    double updatedY = imageLocalPosition.dy * updateRate;

    setState(() {
      _drawnPoints.add(Offset(updatedX, updatedY));
    });
  }

  void _handleImageTap() {
    if (_drawnPoints.isNotEmpty) {
      // 다각형을 완성하기 위해 시작점으로 선을 이어붙임
      _drawnPoints.add(_drawnPoints.first);
    }
  }

  void _clearPoints() {
    setState(() {
      _drawnPoints.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('이미지 화면'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {
              _pickImage();
            },
            child: Text('이미지 불러오기', style: TextStyle(fontSize: 20)),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(200, 50),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              print('라벨 파일 저장 경로');
            },
            child: Text('라벨저장', style: TextStyle(fontSize: 30)),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(200, 50),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _clearPoints();
            },
            child: Text('선 지우기', style: TextStyle(fontSize: 20)),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(200, 50),
            ),
          ),
        ],
      ),
      // Column 밖에 이미지를 배치하는 Container
      floatingActionButton: SafeArea(
        child: Container(
          margin: EdgeInsets.all(20),
          child: GestureDetector(
            onPanUpdate: _handleImageDragUpdate,
            onPanEnd: (_) => _handleImageTap(),
            child: Stack(
              children: [
                imagePath != null
                    ? Image.file(
                        File(Uri.parse(imagePath!).path),
                        key: _imageKey,
                        // height: 650,
                        // width: 1200,
                        fit: BoxFit.cover,
                      )
                    : Container(), // 이미지가 없을 경우 빈 컨테이너
                CustomPaint(
                  painter: _DrawingPainter(_drawnPoints),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<Offset> points;

  _DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
