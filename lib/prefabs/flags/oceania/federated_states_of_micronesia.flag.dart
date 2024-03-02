part of '../oceania.dart';

class FederatedStatesOfMicronesiaFlag extends GameFlag {
  FederatedStatesOfMicronesiaFlag()
      : super(
          name: "Federated States of Micronesia",
          proportion: 10 / 19,
          objects: (size) => [
            PathPart.rect(
              name: '1',
              position: Vector2.zero(),
              size: size,
              color: const Color(0xff75B2DD),
            ),
            PathPart.fromSvgPath(
              "m19.913 4.822 3.762 2.734-1.437 4.422L26 9.245l3.762 2.733-1.437-4.422 3.762-2.734h-4.65L26 .4l-1.437 4.422h-4.65Zm27.265 19.741L51.6 26l-4.422 1.437v4.65l-2.733-3.762-4.423 1.437L42.755 26l-2.733-3.762 4.423 1.437 2.733-3.762v4.65ZM27.437 47.178 26 51.6l-1.437-4.422h-4.65l3.762-2.733-1.437-4.423L26 42.756l3.762-2.734-1.437 4.423 3.762 2.733h-4.65ZM11.978 29.762l-4.423-1.437-2.733 3.762v-4.65L.4 26l4.422-1.437v-4.65l2.733 3.762 4.423-1.437L9.244 26l2.734 3.762Z",
              name: '2',
              areaSize: size,
              position: (bounds) => Vector2(35.2, 6.4),
              color: const Color(0xffffffff),
              previousMustBePlaced: const ['1'],
            ),
          ],
        );
}
