import 'package:equatable/equatable.dart';

final class MonetizationState extends Equatable {
  const MonetizationState({
    required this.isPremium,
    required this.isPurchasePending,
    required this.isProductLoading,
    required this.isProductAvailable,
    required this.productPriceLabel,
    required this.statusMessage,
  });

  const MonetizationState.initial({required this.isPremium})
    : isPurchasePending = false,
      isProductLoading = true,
      isProductAvailable = false,
      productPriceLabel = r'$4.99',
      statusMessage = null;

  final bool isPremium;
  final bool isPurchasePending;
  final bool isProductLoading;
  final bool isProductAvailable;
  final String productPriceLabel;
  final String? statusMessage;

  MonetizationState copyWith({
    bool? isPremium,
    bool? isPurchasePending,
    bool? isProductLoading,
    bool? isProductAvailable,
    String? productPriceLabel,
    String? statusMessage,
    bool clearStatusMessage = false,
  }) {
    return MonetizationState(
      isPremium: isPremium ?? this.isPremium,
      isPurchasePending: isPurchasePending ?? this.isPurchasePending,
      isProductLoading: isProductLoading ?? this.isProductLoading,
      isProductAvailable: isProductAvailable ?? this.isProductAvailable,
      productPriceLabel: productPriceLabel ?? this.productPriceLabel,
      statusMessage: clearStatusMessage
          ? null
          : (statusMessage ?? this.statusMessage),
    );
  }

  @override
  List<Object?> get props => [
    isPremium,
    isPurchasePending,
    isProductLoading,
    isProductAvailable,
    productPriceLabel,
    statusMessage,
  ];
}
