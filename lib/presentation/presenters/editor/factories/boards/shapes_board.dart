import 'package:flags/domain/editor/shapes/shapes.dart';

base class ShapesBoardFactory {
  static Map<String, SShape> create() => {
        "Circle": SCircleShape(),
        "Cross": SCrossShape(),
        "Polyhedron": SPolyhedronShape(),
        "Square": SSquareShape(),
        "Star": SStarShape(),
        "Triangle": STriangleShape(),
      };
}
