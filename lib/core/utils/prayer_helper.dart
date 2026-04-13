/// Helper utility for prayer name-to-ID mapping and related operations
class PrayerHelper {
  PrayerHelper._(); // Private constructor for utility class

  /// Maps prayer name (in any language) to corresponding ID
  static int getPrayerIdByName(String prayerName) {
    final name = prayerName.toLowerCase().trim();

    // Fajr variations
    if (name == 'fajr' || name == 'ফজর' || name == 'الفجر') {
      return 1;
    }
    // Dhuhr variations
    if (name == 'dhuhr' || name == 'zuhr' || name == 'যুহর' || name == 'الظهر') {
      return 2;
    }
    // Asr variations
    if (name == 'asr' || name == 'আসর' || name == 'العصر') {
      return 3;
    }
    // Maghrib variations
    if (name == 'maghrib' || name == 'মাগরিব' || name == 'المغرب') {
      return 4;
    }
    // Isha variations
    if (name == 'isha' || name == 'ইশা' || name == 'العشاء') {
      return 5;
    }

    return 0;
  }

  /// Maps prayer ID to English name
  static String getPrayerNameById(int prayerId) {
    switch (prayerId) {
      case 1: return 'Fajr';
      case 2: return 'Dhuhr';
      case 3: return 'Asr';
      case 4: return 'Maghrib';
      case 5: return 'Isha';
      default: return 'Fajr';
    }
  }
}
