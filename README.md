# Flutter Ditredi

A flutter package that displays large 3D datasets on a transparent canvas.

## Preface

DiTreDi was created to efficiently display datasets and meshes in 3D space. It wasn't intended to create a 3D game engine and is rather useful for displaying static meshes.

## Getting started 

Add imports for ditredi and vector_math_64:

   ```
   import 'package:ditredi/ditredi.dart';
import 'package:vector_math/vector_math_64.dart';
   ```

Add DiTreDi widget to your tree:

   ```
   DiTreDi(
    figures: [
        Cube3D(2, Vector3(0, 0, 0)),
    ],
)
   ```

## Controller

DiTreDiController controls a scene rotation, scale, light.

To set up a controller, keep its reference in a state and pass to the controller parameter.

   ```
   // in a state
@override
void initState() {
    super.initState();
    controller = DiTreDiController();
}

DiTreDi(
    figures: [
        Cube3D(2, Vector3(0, 0, 0)),
    ],
    controller: controller,
)
   ```

Once ready, update controller state by calling:

   ```
   controller.update(rotationY: 30, rotationX: 30);
   ```

To handle input gestures use GestureDetector or DiTreDiDraggable:

   ```
   DiTreDiDraggable(
    controller: controller,
    child: DiTreDi(
        figures: [Cube3D(1, vector.Vector3(0, 0, 0))],
        controller: controller,
    ),
);
   ```


