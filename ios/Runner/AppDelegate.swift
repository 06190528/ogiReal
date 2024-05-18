import UIKit
import Flutter
import BackgroundTasks

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    if #available(iOS 13.0, *) {
      BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.ogirealApp.processing", using: nil) { task in
        self.handleBackgroundTask(task: task)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  @available(iOS 13.0, *)
  func handleBackgroundTask(task: BGTask) {
    if let processingTask = task as? BGProcessingTask {
      processingTask.expirationHandler = {
        processingTask.setTaskCompleted(success: false)
      }
      scheduleNextProcessingTask()
      processingTask.setTaskCompleted(success: true)
    }
  }

  @available(iOS 13.0, *)
  func scheduleNextProcessingTask() {
    let request = BGProcessingTaskRequest(identifier: "com.example.ogirealApp.processing")
    request.requiresNetworkConnectivity = false
    request.requiresExternalPower = false
    
    do {
      try BGTaskScheduler.shared.submit(request)
    } catch {
      print("Could not schedule processing task: \(error)")
    }
  }
}
