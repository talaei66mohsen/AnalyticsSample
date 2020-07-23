//
//  Utility.swift
//  Analytics
//
//  Created by Mohsen on 7/22/20.
//

import Foundation
import AdSupport

struct GlobalConstants {
    struct Strings{
        static let userId = "userId"
        static let sessionId = "sessionId"
        static let startTime = "startTime"
        static let stopTime = "stopTime"
        static let serverAddress = "http://metrix.ir"
        static let bufferedEventsKey = "bufferedEvents"
    }
}


 let Idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
 let osInfo = UIDevice.current.systemVersion
 let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""
 let screenInfo = "\(UIScreen.main.bounds.width)*\(UIScreen.main.bounds.height)"

 var eventTime : String {
    let date = Date()
    let format = DateFormatter()
    format.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return format.string(from: date)
}


public var userID: Int {
    if UserDefaults.standard.value(forKey: GlobalConstants.Strings.userId) as? Int != nil{
        return UserDefaults.standard.value(forKey: GlobalConstants.Strings.userId) as! Int
    }else{
        return 0
    }
}

public var sessionId: Int {
    if UserDefaults.standard.value(forKey: GlobalConstants.Strings.sessionId) as? Int != nil{
        return UserDefaults.standard.value(forKey: GlobalConstants.Strings.sessionId) as! Int
    }else{
        return 0
    }
}
