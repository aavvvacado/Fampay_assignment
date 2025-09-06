import 'package:equatable/equatable.dart';

abstract class CardsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchCardsEvent extends CardsEvent {}

class RefreshCardsEvent extends CardsEvent {}

class DismissCardEvent extends CardsEvent {
  final int cardId;
  DismissCardEvent(this.cardId);
  
  @override
  List<Object?> get props => [cardId];
}

class RemindLaterCardEvent extends CardsEvent {
  final int cardId;
  RemindLaterCardEvent(this.cardId);
  
  @override
  List<Object?> get props => [cardId];
}