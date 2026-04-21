import 'package:equatable/equatable.dart';

final class MonetizationState extends Equatable {
  const MonetizationState({
    required this.isPremium,
    required this.isPurchasePending,
    required this.productPriceLabel,
    required this.statusMessage,
  });

  const MonetizationState.initial({required this.isPremium})
    :
      isPurchasePending = false,
      productPriceLabel = r'$4.99',
      statusMessage = null;

  final bool isPremium;
  final bool isPurchasePending;
  final String productPriceLabel;
  final String? statusMessage;

  MonetizationState copyWith({
    bool? isPremium,
    bool? isPurchasePending,
    String? productPriceLabel,
    String? statusMessage,
    bool clearStatusMessage = false,
  }) {
    return MonetizationState(
      isPremium: isPremium ?? this.isPremium,
      isPurchasePending: isPurchasePending ?? this.isPurchasePending,
      productPriceLabel: productPriceLabel ?? this.productPriceLabel,
      statusMessage:
          clearStatusMessage ? null : (statusMessage ?? this.statusMessage),
    );
  }

  @override
  List<Object?> get props => [
    isPremium,
    isPurchasePending,
    productPriceLabel,
    statusMessage,
  ];
}
