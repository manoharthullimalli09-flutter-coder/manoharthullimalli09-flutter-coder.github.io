import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_model.dart';

abstract class PlaygroundLocalDataSource {
  List<TransactionModel> readTransactions();
  Future<void> writeTransactions(List<TransactionModel> transactions);
  int readSessionsCompleted();
  Future<int> incrementSessionsCompleted();
}

class PlaygroundLocalDataSourceImpl implements PlaygroundLocalDataSource {
  static const _txnKey = 'playground_transactions';
  static const _sessionsKey = 'playground_breathing_sessions';

  final SharedPreferences prefs;

  const PlaygroundLocalDataSourceImpl(this.prefs);

  @override
  List<TransactionModel> readTransactions() {
    final raw = prefs.getString(_txnKey);
    if (raw == null || raw.isEmpty) return const [];

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> writeTransactions(List<TransactionModel> transactions) =>
      prefs.setString(
        _txnKey,
        jsonEncode(transactions.map((t) => t.toJson()).toList()),
      );

  @override
  int readSessionsCompleted() => prefs.getInt(_sessionsKey) ?? 0;

  @override
  Future<int> incrementSessionsCompleted() async {
    final next = readSessionsCompleted() + 1;
    await prefs.setInt(_sessionsKey, next);
    return next;
  }
}
