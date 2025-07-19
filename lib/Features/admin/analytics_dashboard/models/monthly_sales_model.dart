class MonthlySales {
  final int year;
  final int month;
  final int totalSales;
  final double totalRevenue;

  MonthlySales({
    required this.year,
    required this.month,
    required this.totalSales,
    required this.totalRevenue,
  });

  factory MonthlySales.fromJson(Map<String, dynamic> json) {
    return MonthlySales(
      year: json['year'],
      month: json['month'],
      totalSales: json['totalSales'],
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
    );
  }

  String get monthName {
    return DateTime(0, month).toString().split(' ')[1];
  }
}

class CategorySales {
  final String category;
  final double totalSales;
  final int count;
  final String percentage;

  CategorySales({
    required this.category,
    required this.totalSales,
    required this.count,
    required this.percentage,
  });

  factory CategorySales.fromJson(Map<String, dynamic> json) {
    return CategorySales(
      category: json['category'],
      totalSales: (json['totalSales'] as num).toDouble(),
      count: json['count'],
      percentage: json['percentage']?.toString() ?? '0.00',
    );
  }
}