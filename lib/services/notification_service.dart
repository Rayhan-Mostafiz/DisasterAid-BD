// pubspec.yaml e add korun: flutter_local_notifications: ^17.0.0

class NotificationService {
  // final FlutterLocalNotificationsPlugin _notifPlugin =
  //     FlutterLocalNotificationsPlugin();

  /// App start er samay initialize koro
  Future<void> initialize() async {
    // const AndroidInitializationSettings androidSettings =
    //     AndroidInitializationSettings('@mipmap/ic_launcher');
    // const InitializationSettings settings =
    //     InitializationSettings(android: androidSettings);
    // await _notifPlugin.initialize(settings);
    print('NotificationService initialized (demo mode)');
  }

  /// Ekta local notification show koro
  Future<void> showNotification({
    required String title,
    required String body,
    int id = 0,
  }) async {
    // const AndroidNotificationDetails androidDetails =
    //     AndroidNotificationDetails(
    //   'disaster_channel',
    //   'Disaster Alerts',
    //   importance: Importance.max,
    //   priority: Priority.high,
    // );
    // const NotificationDetails details =
    //     NotificationDetails(android: androidDetails);
    // await _notifPlugin.show(id, title, body, details);
    print('NOTIFICATION: $title - $body');
  }

  /// SOS pathano hoyeche notification
  Future<void> sendSOSNotification() async {
    await showNotification(
      title: '🆘 SOS Alert!',
      body: 'Emergency help request pathano hoyeche!',
      id: 999,
    );
  }

  /// Disaster warning notification
  Future<void> sendDisasterWarning(String disasterType, String area) async {
    await showNotification(
      title: '⚠️ Disaster Warning!',
      body: '$disasterType alert: $area elakai satark thakun!',
      id: 1000,
    );
  }
}
