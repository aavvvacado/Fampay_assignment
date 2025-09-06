import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cards_bloc.dart';
import '../bloc/cards_event.dart';
import '../bloc/cards_state.dart';
import '../widgets/card_container.dart';

class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
                      child: Image.asset(
              'assets/fampaylogo.png',
              height: 40,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback to text if image is not found
                return const Text(
                  "FamPay",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              },
            ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<CardsBloc, CardsState>(
        builder: (context, state) {
          if (state is CardsLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading cards...'),
                ],
              ),
            );
          } else if (state is CardsLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<CardsBloc>().add(RefreshCardsEvent());
              },
              child: state.filteredGroups.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No cards to display',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Pull down to refresh',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : CardContainer(groups: state.filteredGroups),
            );
          } else if (state is CardsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading cards',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CardsBloc>().add(RefreshCardsEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
