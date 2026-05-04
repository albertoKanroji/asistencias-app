class ApiConfig {
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://cm-backend.tpp.com.mx/v1/api',
    //defaultValue: 'http://192.168.30.107:7253/v1/api',
  );
}
