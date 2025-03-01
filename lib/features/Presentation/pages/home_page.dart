import 'package:auto_size_text/auto_size_text.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_cash/features/Presentation/bloc/analytic/analytic_bloc.dart';
import 'package:family_cash/features/Presentation/bloc/auth/auth_bloc.dart';
import 'package:family_cash/features/Presentation/bloc/category/category_bloc.dart';
import 'package:family_cash/features/Presentation/bloc/family/family_bloc.dart';
import 'package:family_cash/features/Presentation/bloc/payments/payment_bloc.dart';
import 'package:family_cash/features/Presentation/pages/analytics_page.dart';

import 'package:family_cash/features/Presentation/pages/category_page.dart';
import 'package:family_cash/features/Presentation/pages/open_payments_page.dart';
import 'package:family_cash/features/Presentation/pages/settings_page.dart';
import 'package:family_cash/features/Presentation/widget/error_messsage_widget.dart';
import 'package:family_cash/features/Presentation/widget/format_amount_string.dart';
import 'package:family_cash/features/Presentation/widget/loading_state_widget.dart';
import 'package:family_cash/features/data/models/payment_model.dart';
import 'package:family_cash/features/domain/entity/category_entity.dart';
import 'package:family_cash/features/domain/entity/family_entity.dart';
import 'package:family_cash/features/domain/entity/user_enity.dart';
import 'package:family_cash/locator_server.dart';

part '../widget/home_widgets/login_widget.dart';
part '../widget/home_widgets/family_select_dialog.dart';
part '../widget/home_widgets/registration_dialog.dart';
part '../widget/home_widgets/resert_password_dialog.dart';
part '../widget/home_widgets/family_add_dialog.dart';
part '../widget/home_widgets/user_details_dialog.dart';
part '../widget/home_widgets/app_bar_widget.dart';
part '../widget/category_widget/main_form.dart';
part '../widget/category_widget/balance_analytics_widget.dart';
part '../widget/category_widget/categories_grid_widget.dart';
part '../widget/category_widget/payment_dialog.dart';
part '../widget/category_widget/amount_field_widget.dart';
part '../widget/category_widget/details_widget.dart';
part '../widget/category_widget/virtual_keyboard_widget.dart';
part '../widget/category_widget/number_pressed.dart';
part '../widget/category_widget/payment_pressed.dart';

class HomePage extends StatelessWidget {
  final authBloc = sl<AuthBloc>()..add(LoginFromTokenEvent());
  final familyBloc = sl<FamilyBloc>();
  final categoryBloc = sl<CategoryBloc>();
  final paymentBloc = sl<PaymentBloc>();
  final analyticBloc = sl<AnalyticBloc>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => authBloc,
        ),
        BlocProvider(
          create: (context) => familyBloc,
        ),
        BlocProvider(
          create: (context) => categoryBloc,
        ),
        BlocProvider(
          create: (context) => paymentBloc,
        ),
        BlocProvider(
          create: (context) => analyticBloc,
        )
      ],
      child: Scaffold(
        appBar: _appBarWidget(context, authBloc, familyBloc, paymentBloc),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoadingState) {
              return loadingStateWidget();
            } else if (state is AuthInitialState ||
                state is UnauthenticatedState ||
                state is AuthErrorState) {
              return _buildLoginForm(context, state, authBloc);
            } else if (state is AuthenticatedState) {
              familyBloc.add(GetAllFamiliesEvent());
              return BlocBuilder<FamilyBloc, FamilyState>(
                builder: (context, state) {
                  if (state is FamilyLoadingState) {
                    return loadingStateWidget();
                  }
                  if (state is FamilyErrorState) {
                    errorMessageWidget(state.message);
                  }
                  if (state is FamilyUpdatedDefaultState) {
                    familyBloc.add(GetAllFamiliesEvent());
                  }
                  if (state is FamilyLoadedState) {
                    categoryBloc.add(GetCategoriesEvent());
                    paymentBloc.add(OpenPaymentsEvent());
                    return BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, stateCategory) {
                        if (stateCategory is CategoryLoading) {
                          loadingStateWidget();
                        } else if (stateCategory is CategoryError) {
                          errorMessageWidget(stateCategory.message);
                        } else if (stateCategory is CategoryLoaded) {
                          analyticBloc.add(
                              GetTotalEvent(familyId: state.familyDefaultId));
                          return ApplicationMainForm(
                            categories: stateCategory.categories
                                .where((category) =>
                                    category.familyId == state.familyDefaultId)
                                .toList(),
                            familyDefault: state.familyDefaultId,
                            categoryBloc: categoryBloc,
                            paymentBloc: paymentBloc,
                            analyticBloc: analyticBloc,
                          );
                        }
                        return Container();
                      },
                    );
                  }
                  return Container();
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
