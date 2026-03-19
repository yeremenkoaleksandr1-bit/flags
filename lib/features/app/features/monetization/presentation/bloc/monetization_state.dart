import 'package:equatable/equatable.dart';

final class MonetizationState extends Equatable {
  const MonetizationState({
    required this.isPremium,
    required this.isPurchasePending,
    required this.subscriptionPriceLabel,
    required this.statusMessage,
  });

  const MonetizationState.initial({required bool isPremium})
    : isPremium = isPremium,
      isPurchasePending = false,
      subscriptionPriceLabel = r'$5',
      statusMessage = null;

  final bool isPremium;
  final bool isPurchasePending;
  final String subscriptionPriceLabel;
  final String? statusMessage;

  MonetizationState copyWith({
    bool? isPremium,
    bool? isPurchasePending,
    String? subscriptionPriceLabel,
    String? statusMessage,
    bool clearStatusMessage = false,
  }) {
    return MonetizationState(
      isPremium: isPremium ?? this.isPremium,
      isPurchasePending: isPurchasePending ?? this.isPurchasePending,
      subscriptionPriceLabel:
          subscriptionPriceLabel ?? this.subscriptionPriceLabel,
      statusMessage:
          clearStatusMessage ? null : (statusMessage ?? this.statusMessage),
    );
  }

  @override
  List<Object?> get props => [
    isPremium,
    isPurchasePending,
    subscriptionPriceLabel,
    statusMessage,
  ];
}
