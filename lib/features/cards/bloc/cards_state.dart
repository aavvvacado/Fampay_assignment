import 'package:equatable/equatable.dart';
import '../../../core/models/card_group.dart';

abstract class CardsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CardsInitial extends CardsState {}

class CardsLoading extends CardsState {}

class CardsLoaded extends CardsState {
  final List<CardGroup> groups;
  final List<CardGroup> filteredGroups;
  CardsLoaded(this.groups, {List<CardGroup>? filteredGroups}) 
      : filteredGroups = filteredGroups ?? groups;

  @override
  List<Object?> get props => [groups, filteredGroups];
}

class CardsError extends CardsState {
  final String message;
  CardsError(this.message);

  @override
  List<Object?> get props => [message];
}
