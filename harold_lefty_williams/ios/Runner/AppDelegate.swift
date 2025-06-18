import UIKit
import Flutter
import Firebase
import FirebaseMessaging

@main
@objc class AppDelegate: FlutterAppDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Inicializa o Firebase
    FirebaseApp.configure()

    // Registra plugins Flutter
    GeneratedPluginRegistrant.register(with: self)

    // Configura notificações
    UNUserNotificationCenter.current().delegate = self
    Messaging.messaging().delegate = self

    // Solicita permissão para notificações
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(
      options: authOptions,
      completionHandler: { _, _ in })

    application.registerForRemoteNotifications()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Mostra notificação quando app está em primeiro plano
  func userNotificationCenter(_ center: UNUserNotificationCenter,
      willPresent notification: UNNotification,
      withCompletionHandler completionHandler:
         @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([[.banner, .sound]])
  }

  // Captura o token do FCM quando atualizado
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("🔥 Novo FCM Token: \(fcmToken ?? "nenhum")")
  }
}
