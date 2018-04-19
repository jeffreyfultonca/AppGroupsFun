import Foundation
import BackgroundFetchEvents

struct Providers {
    static let backgroundFetchEventProvider = ProductionBackgroundFetchEventProvider()
    static let notificationProvider = ProductionNotificationProvider()
}
