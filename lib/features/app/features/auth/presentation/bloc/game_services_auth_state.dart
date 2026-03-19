import 'package:equatable/equatable.dart';

final class GameServicesPlayer extends Equatable {
  const GameServicesPlayer({
    required this.playerId,
    required this.displayName,
    this.iconImageBase64,
  });

  final String playerId;
  final String displayName;
  final String? iconImageBase64;

  Map<String, dynamic> toJson() => {
    'playerId': playerId,
    'displayName': displayName,
    'iconImageBase64': iconImageBase64,
  };

  factory GameServicesPlayer.fromJson(Map<String, dynamic> json) {
    return GameServicesPlayer(
      playerId: json['playerId'] as String? ?? '',
      displayName: json['displayName'] as String? ?? 'Player',
      iconImageBase64: json['iconImageBase64'] as String?,
    );
  }

  @override
  List<Object?> get props => [playerId, displayName, iconImageBase64];
}

final class GameServicesAuthState extends Equatable {
  const GameServicesAuthState({
    required this.isLoading,
    required this.player,
    required this.statusMessage,
  });

  const GameServicesAuthState.initial()
    : isLoading = false,
      player = null,
      statusMessage = null;

  final bool isLoading;
  final GameServicesPlayer? player;
  final String? statusMessage;

  bool get isSignedIn => player != null;

  GameServicesAuthState copyWith({
    bool? isLoading,
    GameServicesPlayer? player,
    bool clearPlayer = false,
    String? statusMessage,
    bool clearStatusMessage = false,
  }) {
    return GameServicesAuthState(
      isLoading: isLoading ?? this.isLoading,
      player: clearPlayer ? null : (player ?? this.player),
      statusMessage:
          clearStatusMessage ? null : (statusMessage ?? this.statusMessage),
    );
  }

  @override
  List<Object?> get props => [isLoading, player, statusMessage];
}
