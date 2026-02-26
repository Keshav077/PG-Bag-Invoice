import 'package:flutter/material.dart';

class DisplayField extends StatelessWidget {
  final String label;
  final double value;
  final String? unit;

  const DisplayField({
    super.key,
    required this.label,
    required this.value,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(
            '${value.toStringAsFixed(2)}${unit != null ? ' $unit' : ''}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
