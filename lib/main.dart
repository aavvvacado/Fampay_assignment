import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/api/dio_client.dart';
import 'core/repository/cards_repository.dart';
import 'features/cards/bloc/cards_bloc.dart';
import 'features/cards/bloc/cards_event.dart';
import 'features/cards/view/cards_screen.dart';

void main() {
  final repo = CardsRepository(DioClient().dio);

  runApp(MyApp(repository: repo));
}

class MyApp extends StatelessWidget {
  final CardsRepository repository;
  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FamPay Contextual Cards',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => CardsBloc(repository)..add(FetchCardsEvent()),
        child: const CardsScreen(),
      ),
    );
  }
}
