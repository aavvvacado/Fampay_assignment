import 'package:shared_preferences/shared_preferences.dart';

class CardDismissalService {
  static const String _dismissedCardsKey = 'dismissed_cards';
  static const String _remindLaterCardsKey = 'remind_later_cards';

  // Get dismissed cards (permanent dismissal)
  static Future<Set<int>> getDismissedCards() async {
    final prefs = await SharedPreferences.getInstance();
    final dismissedCardsJson = prefs.getStringList(_dismissedCardsKey) ?? [];
    return dismissedCardsJson.map((id) => int.parse(id)).toSet();
  }

  // Get remind later cards (temporary dismissal)
  static Future<Set<int>> getRemindLaterCards() async {
    final prefs = await SharedPreferences.getInstance();
    final remindLaterCardsJson = prefs.getStringList(_remindLaterCardsKey) ?? [];
    return remindLaterCardsJson.map((id) => int.parse(id)).toSet();
  }

  // Dismiss card permanently
  static Future<void> dismissCard(int cardId) async {
    final prefs = await SharedPreferences.getInstance();
    final dismissedCards = await getDismissedCards();
    dismissedCards.add(cardId);
    
    final dismissedCardsJson = dismissedCards.map((id) => id.toString()).toList();
    await prefs.setStringList(_dismissedCardsKey, dismissedCardsJson);
  }

  // Remind later (temporary dismissal)
  static Future<void> remindLaterCard(int cardId) async {
    final prefs = await SharedPreferences.getInstance();
    final remindLaterCards = await getRemindLaterCards();
    remindLaterCards.add(cardId);
    
    final remindLaterCardsJson = remindLaterCards.map((id) => id.toString()).toList();
    await prefs.setStringList(_remindLaterCardsKey, remindLaterCardsJson);
  }

  // Clear remind later cards (when app starts)
  static Future<void> clearRemindLaterCards() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_remindLaterCardsKey);
  }

  // Check if card should be shown
  static Future<bool> shouldShowCard(int cardId) async {
    final dismissedCards = await getDismissedCards();
    final remindLaterCards = await getRemindLaterCards();
    
    return !dismissedCards.contains(cardId) && !remindLaterCards.contains(cardId);
  }
}
