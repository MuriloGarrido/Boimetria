import 'package:boimetria/ui/core/widgets/picker_field.dart';
import 'package:boimetria/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateField extends StatelessWidget {
  const DateField({
    super.key,
    required this.label,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    this.value,
    this.placeholder,
    this.required = false,
    this.emphasis = false,
    this.onClear,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;

  final DateTime firstDate;
  final DateTime lastDate;

  final String? placeholder;
  final bool required;
  final bool emphasis;
  final VoidCallback? onClear;



  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PickerField(
      label: label,
      placeholder: placeholder ?? l10n.dateFieldPlaceholder,
      value: value == null ? null : _label(context, value!),
      required: required,
      emphasis: emphasis,
      onClear: onClear,
      onTap: () => _pick(context),
    );
  }

  String _label(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    return isToday
        ? AppLocalizations.of(context).dateFieldToday
        : DateFormat.yMd().format(date);
  }

  Future<void> _pick(BuildContext context) async {
    final picked = await showDialog<DateTime>(
      context: context,
      builder: (context) => Dialog(
        child: CalendarDatePicker(
          initialDate: value ?? lastDate,
          firstDate: firstDate,
          lastDate: lastDate,
          onDateChanged: (date) => Navigator.pop(context, date),
        ),
      ),
    );

    if (picked != null) onChanged(picked);
  }
}
