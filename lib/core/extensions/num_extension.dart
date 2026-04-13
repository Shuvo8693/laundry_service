extension NumExtension on num {
  // Add currency formatting
  String get toCurrency => '\$${toStringAsFixed(2)}';

  // Format with commas (e.g., 1,000,000)
  String get withCommas {
    return toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    );
  }

  // Convert to percentage string
  String toPercentage({int decimals = 0}) {
    return '${(this * 100).toStringAsFixed(decimals)}%';
  }
}
