import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  final SharedPreferences _sharedPreferences;
  static const unitAnalysisMinFrequencyKey = "UNIT_ANALYSIS_MIN_FREQUENCY";
  static const unitAnalysisMaxFrequencyKey = "UNIT_ANALYSIS_MAX_FREQUENCY";

  int _unitAnalysisGraphMinFrequency = 40;

  int get unitAnalysisGraphMinFrequency => _unitAnalysisGraphMinFrequency;

  set unitAnalysisGraphMinFrequency(int value) {
    _sharedPreferences.setInt(unitAnalysisMinFrequencyKey, value);
    _unitAnalysisGraphMinFrequency = value;
  }

  int _unitAnalysisGraphMaxFrequency = 40;

  int get unitAnalysisGraphMaxFrequency => _unitAnalysisGraphMaxFrequency;

  set unitAnalysisGraphMaxFrequency(int value) {
    _sharedPreferences.setInt(unitAnalysisMaxFrequencyKey, value);

    _unitAnalysisGraphMaxFrequency = value;
  }

  AppSettings({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences {
    unitAnalysisGraphMinFrequency =
        _sharedPreferences.getInt(unitAnalysisMinFrequencyKey) ??
            unitAnalysisGraphMinFrequency;
    unitAnalysisGraphMaxFrequency =
        _sharedPreferences.getInt(unitAnalysisMaxFrequencyKey) ??
            unitAnalysisGraphMaxFrequency;
  }
}
