import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserState {
  final bool isAuthenticated;
  final String farmerName;
  final String farmName;
  final String mobileNumber;
  final String location;
  final String language; // 'en', 'hi', 'mr'
  final bool isHardwareMode; // false = Simulation Mode, true = Connected Hardware

  const UserState({
    this.isAuthenticated = true,
    this.farmerName = "Ramesh Kumar",
    this.farmName = "My Dairy Farm",
    this.mobileNumber = "+91 98765 43210",
    this.location = "Pune, Maharashtra",
    this.language = "en",
    this.isHardwareMode = false,
  });

  UserState copyWith({
    bool? isAuthenticated,
    String? farmerName,
    String? farmName,
    String? mobileNumber,
    String? location,
    String? language,
    bool? isHardwareMode,
  }) {
    return UserState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      farmerName: farmerName ?? this.farmerName,
      farmName: farmName ?? this.farmName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      location: location ?? this.location,
      language: language ?? this.language,
      isHardwareMode: isHardwareMode ?? this.isHardwareMode,
    );
  }
}

class AuthNotifier extends StateNotifier<UserState> {
  AuthNotifier() : super(const UserState());

  void login(String identifier, String password) {
    state = state.copyWith(
      isAuthenticated: true,
      farmerName: identifier.contains('@') ? identifier.split('@').first : "Ramesh Kumar",
    );
  }

  void signup(String name, String phone, String location) {
    state = state.copyWith(
      isAuthenticated: true,
      farmerName: name.isNotEmpty ? name : "Ramesh Kumar",
      mobileNumber: phone,
      location: location,
    );
  }

  void logout() {
    state = state.copyWith(isAuthenticated: false);
  }

  void setLanguage(String lang) {
    state = state.copyWith(language: lang);
  }

  void toggleHardwareMode(bool isHardware) {
    state = state.copyWith(isHardwareMode: isHardware);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, UserState>((ref) {
  return AuthNotifier();
});
