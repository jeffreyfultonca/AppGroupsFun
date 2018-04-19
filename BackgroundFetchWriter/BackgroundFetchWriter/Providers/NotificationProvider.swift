import UserNotifications

class ProductionNotificationProvider {
    
    // MARK: - Stored Properties
    
    private let userNotificationCenter = UNUserNotificationCenter.current()
    
    // MARK: - Registration
    
    func attemptToRegisterForNotifications(
        resultQueue: DispatchQueue,
        resultHandler: @escaping (AsyncResult<Void>) -> Void)
    {
        userNotificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard error == nil else {
                resultQueue.async { resultHandler( .failure(error!) ) }
                return
            }
            
            resultQueue.async { resultHandler( .success(()) ) }
        }
    }
    
    func postDidPerformFetchNotification() {
        let identifier = "didPerformFetchNotification"
        
        let content = UNMutableNotificationContent()
        content.title = "didPerformFetchNotification"
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
        
        userNotificationCenter.add(request) { error in
            if let error = error {
                fatalError("\(error)")
            }
        }
    }
}
