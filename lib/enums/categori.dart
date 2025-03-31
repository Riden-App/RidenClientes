enum RideCategory {
  standard,
  comfort,
  spacious,
}

extension RideCategoryExtension on RideCategory {
  String get value {
    switch (this) {
      case RideCategory.standard:
        return 'Estándar';
      case RideCategory.comfort:
        return 'Confort';
      case RideCategory.spacious:
        return 'Espacioso';
      default:
        return 'Estándar';
    }
  }

  static RideCategory? fromString(String str) {
    for (var category in RideCategory.values) {
      if (category.value == str) {
        return category;
      }
    }
    return null; // Retorna null si no coincide
  }
}
