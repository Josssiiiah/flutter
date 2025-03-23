class AppConfig {
  // API URLs
  static const String baseUrl = 'https://api.example.com';
  
  // Feature flags
  static const bool isDarkModeEnabled = true;
  static const bool isOfflineEnabled = true;
  
  // App information
  static const String appName = 'Flutter Fullstack';
  static const String appVersion = '1.0.0';
  
  // Timeouts
  static const int connectionTimeout = 30000; // milliseconds
  static const int receiveTimeout = 30000; // milliseconds
} 