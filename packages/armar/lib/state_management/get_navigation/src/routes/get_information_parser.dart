// import 'package:flutter/foundation.dart';
// import 'package:flutter/widgets.dart';
//
// import '../../../get.dart';
//
// class GetInformationParser extends RouteInformationParser<RouteDecoder> {
//   factory GetInformationParser.createInformationParser(
//       {String initialRoute = '/'}) {
//     Get.log(initialRoute, isError: true);
//     return GetInformationParser(initialRoute: initialRoute);
//   }
//
//   final String initialRoute;
//
//   GetInformationParser({
//     required this.initialRoute,
//   }) {
//     Get.log(initialRoute);
//     Get.log('GetInformationParser is created !');
//   }
//
//   @override
//   SynchronousFuture<RouteDecoder> parseRouteInformation(
//     RouteInformation routeInformation,
//   ) {
//     String? location;
//     if (location == '/') {
//       location = routeInformation.uri.path;
//
//       // if (!(Get.rootController.rootDelegate)
//       //     .registeredRoutes
//       //     .any((element) => element.name == '/')) {
//       //   location = initialRoute;
//       // }
//     }
//
//     Get.log('GetInformationParser: route location: $location');
//
//     final routeName = location ?? initialRoute;
//
//     return SynchronousFuture(RouteDecoder.fromRoute(routeName));
//   }
//
//   @override
//   RouteInformation restoreRouteInformation(RouteDecoder configuration) {
//     return RouteInformation(
//       uri: Uri(
//         path: configuration.pageSettings?.name ?? '',
//         queryParameters: configuration.parameters,
//       ),
//       state: null,
//     );
//   }
// }
