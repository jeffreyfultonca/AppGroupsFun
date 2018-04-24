import UIKit
import BackgroundFetchEvents

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Stored Properties
    
    var window: UIWindow?
    private let backgroundFetchEventProvider = Providers.backgroundFetchEventProvider
    private let notificationProvider = Providers.notificationProvider
    
    // MARK: - UIApplicationDelegate
    
    func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool
    {
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        notificationProvider.attemptToRegisterForNotifications(resultQueue: .main) { result in
            switch result {
            case .failure(let error):
                fatalError("\(error)")
                
            case .success:
                print("Successfully registered for notifications")
            }
        }
        
        return true
    }

    func application(
        _ application: UIApplication,
        performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        backgroundFetchEventProvider.recordBackgroundFetchEvent()
        
        if backgroundFetchEventProvider.shouldNotifyUserOfBackgroundFetchEvents {
            notificationProvider.postDidPerformFetchNotification()
        }
        
        completionHandler(backgroundFetchEventProvider.backgroundFetchResultToReturn)
    }
}
