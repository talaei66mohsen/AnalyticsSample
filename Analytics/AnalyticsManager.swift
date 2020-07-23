//
//  AnalyticsManager.swift
//  Analytics
//
//  Created by Mohsen on 7/22/20.
//

import Foundation
import AdSupport

//////////////// This class will act as the top level API for logging events, and an instance of this class will be dependency injected into any view controller that wants to use our system
public class AnalyticsManager: NSObject {
    
    public static let shared = AnalyticsManager()
    
    override init() {
        super.init()
      NotificationCenter.default.addObserver(self,
          selector: #selector(applicationWillTerminate(notification:)),
          name: UIApplication.willTerminateNotification,
          object: nil)
    }
    
    @objc func applicationWillTerminate(notification: Notification) {
        AnalyticsManager.shared.seeeionStop()
    }

    deinit {
      NotificationCenter.default.removeObserver(self)
    }
    
    public func trackCustomEvent(_ event: EventProtocol) {
        var prettyPrintedEvent = EventModel()
        prettyPrintedEvent.eventName = event.eventName
        prettyPrintedEvent.eventTime = eventTime
        prettyPrintedEvent.sessionId = sessionId
        prettyPrintedEvent.attributes = String(data: try! JSONSerialization.data(withJSONObject: event.attributes, options: .prettyPrinted), encoding: String.Encoding.utf8)!.replacingOccurrences(of: "\n", with: "")
        EventManager.shared.addEvent(event: prettyPrintedEvent)
    }
    
     func seeeionStop() {
        guard let sessionID = UserDefaults.standard.value(forKey: GlobalConstants.Strings.sessionId) as? Int else{return}
        guard let userId = UserDefaults.standard.value(forKey: GlobalConstants.Strings.userId) as? Int else{return}
        let startTime = UserDefaults.standard.value(forKey: GlobalConstants.Strings.startTime) as? Date
        let stopTime = Date()
        let sessionDuratioin = Calendar.current.dateComponents([.second], from: startTime ?? Date(), to: stopTime)
        Services.sessionStop(sessionID: sessionID, userId: userId, sessionDuratioin: sessionDuratioin.second ?? 0)
        UserDefaults.standard.set(nil, forKey: GlobalConstants.Strings.sessionId)
        UserDefaults.standard.set(nil, forKey: GlobalConstants.Strings.startTime)
        print("sessionStop")
    }
    
     func seeeionStart() {
        var userId : Int
        UserDefaults.standard.set(Date(), forKey: GlobalConstants.Strings.startTime)
        let sessionID = UUID().uuidString.hashValue
        UserDefaults.standard.set(sessionID, forKey: GlobalConstants.Strings.sessionId)
        if userID == 0 {
            let userID = UUID().uuidString.hashValue
            UserDefaults.standard.set(userID, forKey: GlobalConstants.Strings.userId)
            userId = userID
        }else{
            userId = userID
        }
        Services.sessionStart(sessionID: sessionID, userId: userId)
    }
    
   public func appDidLaunch() {
       self.seeeionStart()
    }
}
