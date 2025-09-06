import 'package:flutter_bloc/flutter_bloc.dart';
import 'cards_event.dart';
import 'cards_state.dart';
import '../../../core/repository/cards_repository.dart';
import '../../../core/services/card_dismissal_service.dart';
import '../../../core/models/card_group.dart';
import '../../../core/models/card_model.dart';

class CardsBloc extends Bloc<CardsEvent, CardsState> {
  final CardsRepository repository;
  CardsBloc(this.repository) : super(CardsInitial()) {
    on<FetchCardsEvent>(_onFetch);
    on<RefreshCardsEvent>(_onRefresh);
    on<DismissCardEvent>(_onDismissCard);
    on<RemindLaterCardEvent>(_onRemindLaterCard);
  }

  Future<void> _onFetch(
      FetchCardsEvent event, Emitter<CardsState> emit) async {
    emit(CardsLoading());
    try {
      final response = await repository.fetchCards();
      final filteredGroups = await _filterCards(response.hcGroups);
      emit(CardsLoaded(response.hcGroups, filteredGroups: filteredGroups));
    } catch (e) {
      emit(CardsError(e.toString()));
    }
  }

  Future<void> _onRefresh(
      RefreshCardsEvent event, Emitter<CardsState> emit) async {
    try {
      final response = await repository.fetchCards();
      final filteredGroups = await _filterCards(response.hcGroups);
      emit(CardsLoaded(response.hcGroups, filteredGroups: filteredGroups));
    } catch (e) {
      emit(CardsError(e.toString()));
    }
  }

  Future<void> _onDismissCard(
      DismissCardEvent event, Emitter<CardsState> emit) async {
    await CardDismissalService.dismissCard(event.cardId);
    
    if (state is CardsLoaded) {
      final currentState = state as CardsLoaded;
      final filteredGroups = await _filterCards(currentState.groups);
      emit(CardsLoaded(currentState.groups, filteredGroups: filteredGroups));
    }
  }

  Future<void> _onRemindLaterCard(
      RemindLaterCardEvent event, Emitter<CardsState> emit) async {
    await CardDismissalService.remindLaterCard(event.cardId);
    
    if (state is CardsLoaded) {
      final currentState = state as CardsLoaded;
      final filteredGroups = await _filterCards(currentState.groups);
      emit(CardsLoaded(currentState.groups, filteredGroups: filteredGroups));
    }
  }

  Future<List<CardGroup>> _filterCards(List<CardGroup> groups) async {
    final filteredGroups = <CardGroup>[];
    
    for (final group in groups) {
      final filteredCards = <CardModel>[];
      
      for (final card in group.cards) {
        final shouldShow = await CardDismissalService.shouldShowCard(card.id);
        if (shouldShow) {
          filteredCards.add(card);
        }
      }
      
      if (filteredCards.isNotEmpty) {
        filteredGroups.add(CardGroup(
          id: group.id,
          name: group.name,
          designType: group.designType,
          cardType: group.cardType,
          cards: filteredCards,
          isScrollable: group.isScrollable,
          height: group.height,
          isFullWidth: group.isFullWidth,
          slug: group.slug,
          level: group.level,
        ));
      }
    }
    
    return filteredGroups;
  }
}
