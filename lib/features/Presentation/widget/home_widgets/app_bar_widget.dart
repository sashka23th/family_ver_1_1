part of '../../pages/home_page.dart';

PreferredSizeWidget _appBarWidget(BuildContext context, AuthBloc authBloc,
    FamilyBloc familyBloc, PaymentBloc paymentBloc) {
  return AppBar(
    title: BlocBuilder<FamilyBloc, FamilyState>(
      builder: (context, state) {
        return (state is FamilyLoadedState)
            ? Text(state.familyDefault.name)
            : const Text('Family cash balance');
      },
    ),
    actions: [
      BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthenticatedState) {
            return Row(
              children: [
                BlocBuilder<PaymentBloc, PaymentState>(
                  builder: (context, statePayments) {
                    if (statePayments is PaymentsLoadedState) {
                      return IconButton(
                        icon: Stack(
                          children: [
                            const Icon(Icons.payment),
                            if (statePayments.payments.isNotEmpty)
                              Positioned(
                                right: 0,
                                child: CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Colors.red,
                                  child: Text(
                                    '${statePayments.payments.length}',
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.white),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OpenPaymentsPage(
                                    payments: statePayments.payments,
                                    onClick: () => paymentBloc
                                        .add(RefreshPaymentsEvent()))),
                          );
                        },
                      );
                    } else {
                      return const SizedBox
                          .shrink(); // Если нет, возвращаем пустой виджет;
                    }
                  },
                ),
                // Иконка параметров
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsPage()),
                    );
                  },
                ),

                BlocBuilder<FamilyBloc, FamilyState>(
                  builder: (context, state) {
                    return IconButton(
                      icon: const Icon(Icons.family_restroom),
                      onPressed: () => _showFamilySelectionDialog(
                          context, state, familyBloc),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.person),
                  color: Colors.green,
                  onPressed: () => _showUserDetails(
                      context, state.user, authBloc, familyBloc),
                ),
              ],
            );
          }
          return Container();
        },
      ),
    ],
  );
}
