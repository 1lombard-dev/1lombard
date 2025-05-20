import 'package:flutter/material.dart';
import 'package:lombard/src/core/theme/resources.dart';

class CustomRadio<T> extends StatefulWidget {
  const CustomRadio({
    required this.value,
    required this.onChanged,
    super.key,
    this.groupValue,
    this.size = 24,
    this.color,
  });
  final double size;
  final T value;
  final T? groupValue;
  final void Function(T index) onChanged;
  final Color? color;

  @override
  State createState() => _CustomRadioState();
}

class _CustomRadioState extends State<CustomRadio> {
  @override
  Widget build(BuildContext context) {
    final selected = widget.value == widget.groupValue;

    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      onTap: () => widget.onChanged(widget.value),
      child: Container(
        height: widget.size,
        width: widget.size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Center(
          child: selected ? const Icon(Icons.radio_button_checked) : const Icon(Icons.radio_button_off),
        ),
      ),
    );
  }
}
