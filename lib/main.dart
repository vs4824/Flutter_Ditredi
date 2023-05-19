import 'package:ditredi/ditredi.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _displayMode = DisplayMode.cubes;
  final _cubes = _generateCubes();
  final _points = _generatePoints().toList();

  final _controller = DiTreDiController(
    rotationX: -20,
    rotationY: 30,
    light: vector.Vector3(-0.5, -0.5, 0.5),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      title: 'DiTreDi Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Flex(
            crossAxisAlignment: CrossAxisAlignment.start,
            direction: Axis.vertical,
            children: [
              if (_displayMode == DisplayMode.cubes)
                Expanded(
                  child: DiTreDiDraggable(
                    controller: _controller,
                    child: DiTreDi(
                      figures: _cubes.toList(),
                      controller: _controller,
                    ),
                  ),
                ),
              if (_displayMode == DisplayMode.wireframe)
                Expanded(
                  child: DiTreDiDraggable(
                    controller: _controller,
                    child: DiTreDi(
                      figures: [
                        ..._cubes
                            .map((e) => e.toLines())
                            .flatten()
                            .map((e) =>
                            e.copyWith(color: Colors.red.withAlpha(20)))
                            .toList()
                      ],
                      controller: _controller,
                      // disable z index to boost drawing performance
                      // for wireframes and points
                      config: const DiTreDiConfig(
                        supportZIndex: false,
                      ),
                    ),
                  ),
                ),
              if (_displayMode == DisplayMode.points)
                Expanded(
                  child: DiTreDiDraggable(
                    controller: _controller,
                    child: DiTreDi(
                      figures: _points,
                      controller: _controller,
                      // disable z index to boost drawing performance
                      // for wireframes and points
                      config: const DiTreDiConfig(
                        defaultPointWidth: 2,
                        supportZIndex: false,
                      ),
                    ),
                  ),
                ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Drag to rotate. Scroll to zoom"),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: DisplayMode.values
                    .map((e) => Material(
                  child: InkWell(
                    onTap: () => setState(() => _displayMode = e),
                    child: ListTile(
                      title: Text(e.title),
                      leading: Radio<DisplayMode>(
                        value: e,
                        groupValue: _displayMode,
                        onChanged: (e) => setState(
                              () => _displayMode = e ?? DisplayMode.cubes,
                        ),
                      ),
                    ),
                  ),
                ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Iterable<Cube3D> _generateCubes() sync* {
  final colors = [
    Colors.grey.shade200,
    Colors.grey.shade300,
    Colors.grey.shade400,
    Colors.grey.shade500,
    Colors.grey.shade600,
    Colors.grey.shade700,
    Colors.grey.shade800,
    Colors.grey.shade900,
  ];

  const count = 8;
  for (var x = count; x > 0; x--) {
    for (var y = count; y > 0; y--) {
      for (var z = count; z > 0; z--) {
        yield Cube3D(
          0.9,
          vector.Vector3(
            x.toDouble() * 2,
            y.toDouble() * 2,
            z.toDouble() * 2,
          ),
          color: colors[(colors.length - y) % colors.length],
        );
      }
    }
  }
}

Iterable<Point3D> _generatePoints() sync* {
  for (var x = 0; x < 10; x++) {
    for (var y = 0; y < 10; y++) {
      for (var z = 0; z < 10; z++) {
        yield Point3D(
          vector.Vector3(
            x.toDouble() * 2,
            y.toDouble() * 2,
            z.toDouble() * 2,
          ),
        );
      }
    }
  }
}

enum DisplayMode {
  cubes,
  wireframe,
  points,
}

extension DisplayModeTitle on DisplayMode {
  String get title {
    switch (this) {
      case DisplayMode.cubes:
        return "Cubes";
      case DisplayMode.wireframe:
        return "Wireframe";
      case DisplayMode.points:
        return "Points";
    }
  }
}
