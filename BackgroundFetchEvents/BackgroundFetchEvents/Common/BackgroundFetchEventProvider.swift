import Foundation
import UIKit

// MARK: - BackgroundFetchEventProvider

public protocol BackgroundFetchEventProvider {
    var backgroundFetchEvents: Set<BackgroundFetchEvent> { get }
    func recordBackgroundFetchEvent()
    var backgroundFetchResultToReturn: UIBackgroundFetchResult { get set }
    var shouldNotifyUserOfBackgroundFetchEvents: Bool { get set }
}

// MARK: - ProductionBackgroundFetchEventProvider

public class ProductionBackgroundFetchEventProvider: BackgroundFetchEventProvider {
    
    // TODO: Replace UserDefaults storage with NSFileCoordinator and NSFilePresenter implementation to enable "notification" for file changes from any process. Attempt to observe changes to the shared UserDefaults file just to see if it's possible.
    
    // MARK: - Stored Properties
    
    struct UserDefaultKeys {
        static let backgroundFetchEvents = "backgroundFetchEvents"
        static let backgroundFetchResultToReturn = "backgroundFetchResultToReturn"
        static let shouldNotifyUserOfBackgroundFetchEvents = "shouldNotifyUserOfBackgroundFetchEvents"
    }
    private let sharedUserDefaults = UserDefaults(suiteName: "group.ca.jeffreyfulton.app-groups-fun")!
    private let notificationCenter = NotificationCenter.default
    private let queue = DispatchQueue(label: "ProductionBackgroundFetchEventProvider.queue", qos: .background)
    
    // MARK: - Lifecycle
    
    public init() {}
    
    // MARK: - BackgroundFetchEvents
    
    public var backgroundFetchEvents: Set<BackgroundFetchEvent> {
        get {
            return queue.sync {
                return sharedUserDefaults.codableValue(forKey: UserDefaultKeys.backgroundFetchEvents) ?? []
            }
        }
        set {
            queue.sync {
                sharedUserDefaults.set(codable: newValue, forKey: UserDefaultKeys.backgroundFetchEvents)
            }
            
            DispatchQueue.main.async {
                self.notificationCenter.post(name: .didUpdateBackgroundFetchEvents, object: self)
            }
        }
    }
    
    public func recordBackgroundFetchEvent() {
        let backgroundFetchEvent = BackgroundFetchEvent(
            occuredAt: .now,
            returnedResult: backgroundFetchResultToReturn
        )
        backgroundFetchEvents.insert(backgroundFetchEvent)
    }
    
    // MARK: - UIBackgroundFetchResult
    
    public var backgroundFetchResultToReturn: UIBackgroundFetchResult {
        get {
            guard
                let rawValue = sharedUserDefaults.value(forKey: UserDefaultKeys.backgroundFetchResultToReturn) as? UInt,
                let backgroundFetchResult = UIBackgroundFetchResult(rawValue: rawValue)
                else { return .noData }
            
            return backgroundFetchResult
        }
        set {
            sharedUserDefaults.set(newValue.rawValue, forKey: UserDefaultKeys.backgroundFetchResultToReturn)
        }
    }
    
    // MARK: - User Notifications
    
    public var shouldNotifyUserOfBackgroundFetchEvents: Bool {
        get { return sharedUserDefaults.bool(forKey: UserDefaultKeys.shouldNotifyUserOfBackgroundFetchEvents) }
        set { sharedUserDefaults.set(newValue, forKey: UserDefaultKeys.shouldNotifyUserOfBackgroundFetchEvents) }
    }
}
