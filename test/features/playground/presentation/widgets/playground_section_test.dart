import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_portfolio/features/playground/data/datasources/playground_local_datasource.dart';
import 'package:flutter_portfolio/features/playground/data/repositories/streak_repository_impl.dart';
import 'package:flutter_portfolio/features/playground/data/repositories/tally_repository_impl.dart';
import 'package:flutter_portfolio/features/playground/domain/repositories/streak_repository.dart';
import 'package:flutter_portfolio/features/playground/domain/repositories/tally_repository.dart';
import 'package:flutter_portfolio/features/playground/domain/usecases/calculate_emi_usecase.dart';
import 'package:flutter_portfolio/features/playground/domain/usecases/calculate_salary_usecase.dart';
import 'package:flutter_portfolio/features/playground/domain/usecases/calculate_sip_usecase.dart';
import 'package:flutter_portfolio/features/playground/domain/usecases/streak_usecases.dart';
import 'package:flutter_portfolio/features/playground/domain/usecases/tally_usecases.dart';
import 'package:flutter_portfolio/features/playground/presentation/bloc/breathing_cubit.dart';
import 'package:flutter_portfolio/features/playground/presentation/bloc/emi_cubit.dart';
import 'package:flutter_portfolio/features/playground/presentation/bloc/salary_cubit.dart';
import 'package:flutter_portfolio/features/playground/presentation/bloc/sip_cubit.dart';
import 'package:flutter_portfolio/features/playground/presentation/bloc/tally_bloc.dart';
import 'package:flutter_portfolio/features/playground/presentation/widgets/playground_section.dart';

import '../../../../helpers/pump_app.dart';

final sl = GetIt.instance;

Future<void> registerPlayground() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();

  sl.registerLazySingleton<PlaygroundLocalDataSource>(
    () => PlaygroundLocalDataSourceImpl(prefs),
  );
  sl.registerLazySingleton<TallyRepository>(() => TallyRepositoryImpl(sl()));
  sl.registerLazySingleton<StreakRepository>(() => StreakRepositoryImpl(sl()));
  sl.registerLazySingleton(() => const CalculateEmiUseCase());
  sl.registerLazySingleton(() => const CalculateSipUseCase());
  sl.registerLazySingleton(() => const CalculateSalaryUseCase());
  sl.registerLazySingleton(() => GetTransactionsUseCase(sl()));
  sl.registerLazySingleton(() => SaveTransactionsUseCase(sl()));
  sl.registerLazySingleton(() => GetSessionsCompletedUseCase(sl()));
  sl.registerLazySingleton(() => RecordBreathingSessionUseCase(sl()));
  sl.registerFactory(() => EmiCubit(calculateEmi: sl()));
  sl.registerFactory(() => SipCubit(calculateSip: sl()));
  sl.registerFactory(() => SalaryCubit(calculateSalary: sl()));
  sl.registerFactory(
    () => TallyBloc(getTransactions: sl(), saveTransactions: sl()),
  );
  sl.registerFactory(
    () => BreathingCubit(getSessions: sl(), recordSession: sl()),
  );
}

void main() {
  setUp(registerPlayground);
  tearDown(() => sl.reset());

  Future<void> pumpAt(WidgetTester tester, Size size) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpApp(
      const SingleChildScrollView(child: PlaygroundSection()),
    );
    await tester.pumpAndSettle();
  }

  const desktop = Size(1440, 2400);
  const mobile = Size(390, 2400);

  testWidgets('opens on the tally with every tool reachable', (tester) async {
    await pumpAt(tester, desktop);

    for (final label in [
      'Money Tally',
      'In-Hand Salary',
      'EMI',
      'SIP',
      'Breathe',
    ]) {
      expect(find.text(label), findsWidgets, reason: '$label tab missing');
    }
    expect(find.textContaining('No entries yet'), findsOneWidget);
  });

  testWidgets('adding a transaction updates the balance and the list',
      (tester) async {
    await pumpAt(tester, desktop);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'What was it for?'),
      'Coffee',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Amount'),
      '250',
    );
    await tester.tap(find.text('Add entry'));
    await tester.pumpAndSettle();

    expect(find.text('Coffee'), findsOneWidget);
    expect(find.text('−₹250'), findsOneWidget);
    expect(find.textContaining('No entries yet'), findsNothing);
  });

  testWidgets('the form rejects an empty label and a non-numeric amount',
      (tester) async {
    await pumpAt(tester, desktop);

    await tester.tap(find.text('Add entry'));
    await tester.pumpAndSettle();

    expect(find.text('Add a short label'), findsOneWidget);
    expect(find.text('Enter a number'), findsOneWidget);
    expect(find.textContaining('No entries yet'), findsOneWidget);
  });

  testWidgets('income and expense produce a net balance', (tester) async {
    await pumpAt(tester, desktop);

    Future<void> add(String label, String amount, {bool income = false}) async {
      if (income) {
        // 'Income' also labels a results tile, so target the toggle by key.
        await tester.tap(find.byKey(const Key('tally-type-income')));
        await tester.pumpAndSettle();
      }
      await tester.enterText(
        find.widgetWithText(TextFormField, 'What was it for?'),
        label,
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Amount'),
        amount,
      );
      await tester.tap(find.text('Add entry'));
      await tester.pumpAndSettle();
    }

    await add('Rent', '20000');
    await add('Payday', '50000', income: true);

    // 50,000 in minus 20,000 out.
    expect(find.text('₹30,000'), findsOneWidget);
  });

  testWidgets('switching to the salary tool shows its tax-regime caveat',
      (tester) async {
    await pumpAt(tester, desktop);

    await tester.tap(find.text('In-Hand Salary'));
    await tester.pumpAndSettle();

    expect(find.textContaining('New Tax Regime'), findsOneWidget);
    expect(find.text('Monthly in-hand (approx.)'), findsOneWidget);
  });

  testWidgets('EMI tool renders a monthly instalment', (tester) async {
    await pumpAt(tester, desktop);

    await tester.tap(find.text('EMI'));
    await tester.pumpAndSettle();

    expect(find.text('Monthly EMI'), findsOneWidget);
    expect(find.text('Loan amount'), findsOneWidget);
  });

  testWidgets('SIP tool renders an estimated corpus', (tester) async {
    await pumpAt(tester, desktop);

    await tester.tap(find.text('SIP'));
    await tester.pumpAndSettle();

    expect(find.text('Estimated value'), findsOneWidget);
  });

  testWidgets('breathing tool starts and stops without leaking a ticker',
      (tester) async {
    await pumpAt(tester, desktop);

    await tester.tap(find.text('Breathe'));
    await tester.pumpAndSettle();

    expect(find.text('Start session'), findsOneWidget);

    await tester.tap(find.text('Start session'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Breathe in'), findsOneWidget);

    await tester.tap(find.text('Stop'));
    await tester.pumpAndSettle();
    expect(find.text('Start session'), findsOneWidget);
  });

  testWidgets('every tool lays out at 390px without overflowing',
      (tester) async {
    await pumpAt(tester, mobile);

    for (final label in ['In-Hand Salary', 'EMI', 'SIP', 'Breathe']) {
      await tester.tap(find.text(label).first);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '$label overflowed');
    }
  });
}
