import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

enum TransactionFilter {
  all(LocaleKeys.all, LocaleKeys.transaction_history_empty_message),
  incoming(
    LocaleKeys.incoming,
    LocaleKeys.transaction_history_incoming_empty_message,
  ),
  outgoing(
    LocaleKeys.outgoing,
    LocaleKeys.transaction_history_outgoing_empty_message,
  );

  const TransactionFilter(this._label, this._emptyMessage);

  final String _label;
  final String _emptyMessage;

  String get label => _label.translate;
  String get emptyMessage => _emptyMessage.translate;
}
