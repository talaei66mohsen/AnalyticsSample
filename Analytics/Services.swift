//
//  Services.swift
//  Analytics
//
//  Created by Mohsen on 7/22/20.
//

import Foundation

class Services {
    
    class func commonService(url:String,parameters:[String:Any], CompletionHandler : @escaping(Bool) -> Void){
    if Reachability.shared.isConnectedToNetwork() == false {
        CompletionHandler(false)
        return
    }else{
        CompletionHandler(true)
        guard let serviceUrl = URL(string: url) else { return}
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        request.httpBody = httpBody
        request.timeoutInterval = 20
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
    
    // MARK: - sessionStart
    class func sessionStart(sessionID:Int,userId:Int){
        let startTime = UserDefaults.standard.value(forKey: GlobalConstants.Strings.startTime) as? Date
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let Url = String(format: "\(GlobalConstants.Strings.serverAddress)/session/start")
        let parameters: [String:Any] = [
            "sessionID" : sessionID,
            "userId" : userId,
            "osInfo" : osInfo,
            "eventTime" : format.string(from: startTime ?? Date()),
            "bundleIdentifier" : bundleIdentifier,
            "Idfa" : Idfa,
            "screenInfo" : screenInfo]
        commonService(url: Url, parameters: parameters, CompletionHandler: {status in
            switch status{
            case true : break
                
            case false :
                return
            }
        })
    }
    
    // MARK: - sessionStop
    class func sessionStop(sessionID:Int,userId:Int,sessionDuratioin:Int){
        let stopTime = UserDefaults.standard.value(forKey: GlobalConstants.Strings.stopTime) as? Date
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let Url = String(format: "\(GlobalConstants.Strings.serverAddress)/session/stop/")
        let parameters: [String:Any] = [
            "sessionID" : sessionID,
            "userId" : userId,
            "eventTime" : format.string(from: stopTime ?? Date()) ,
            "bundleIdentifier" : bundleIdentifier,
            "sessionDuratioin":sessionDuratioin]
        commonService(url: Url, parameters: parameters, CompletionHandler: {status in
            switch status{
            case true : break
                
            case false :
                return
            }
        })
    }
    
    // MARK: - customEvent
      class func customEvent(events: [EventModel], CompletionHandler : @escaping(Bool) -> Void){
    if Reachability.shared.isConnectedToNetwork() == false {
        CompletionHandler(false)
        return
    }else{
        let Url = String(format: "\(GlobalConstants.Strings.serverAddress)/event/")
        
        var psrsmeterArray:[[String:Any]] = []
        for event in events{
            psrsmeterArray.append(["sessionID"        : event.sessionId ?? 0,
                                   "userId"           : userID,
                                   "attributes"       : event.attributes.replacingOccurrences(of: "\n", with: "") ,
                                   "eventName"        : event.eventName ?? "",
                                   "eventTime"        : event.eventTime ?? "",
                                   "bundleIdentifier" : bundleIdentifier])
        }
        
        print(psrsmeterArray)
        commonService(url: Url, parameters: ["listOfEvents": psrsmeterArray], CompletionHandler: {status in
            switch status{
            case true :
                CompletionHandler(true)
            case false :
                CompletionHandler(false)
            }
        })
}
}
}
