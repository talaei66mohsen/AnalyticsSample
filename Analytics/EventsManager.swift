//
//  EventsManager.swift
//  Analytics
//
//  Created by Mohsen on 7/22/20.
//

import Foundation

class EventManager {
    
    public static let shared = EventManager()
    var timer:Timer?
    
    init() {
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    
    @objc func runTimedCode() {
        sendBufferedEvents()
    }
    
    func addEvent(event: EventModel) {
        let newIdForEvent = UUID().uuidString
        if var bufferedEvents = getBufferedEvents() {
            bufferedEvents[newIdForEvent] = event
            set(codable: bufferedEvents, forKey: GlobalConstants.Strings.bufferedEventsKey)
            print(bufferedEvents.count)
//            if bufferedEvents.count > 2 {
//                sendBufferedEvents()
//            }
            
        } else {
            set(codable: [newIdForEvent:event], forKey: GlobalConstants.Strings.bufferedEventsKey)
        }
    }
    
    
    private func sendBufferedEvents() {
        if let savedEvents = getBufferedEvents() , savedEvents.count > 0 {
            
            var events: [EventModel] = []
            for event in savedEvents {
                events.append(event.value)
            }
            
            Services.customEvent(events: events, CompletionHandler: {status in
                switch status{
                case true :
                    //if network call succeeded
                    for event in savedEvents {
                        self.removeEventFromBuffer(eventId: event.key)
                    }
                case false :
                    return
                }
            })
        }
    }
    
    private func getBufferedEvents() -> [String:EventModel]? {
        if let bufferedEventsData = UserDefaults.standard.value(forKey: GlobalConstants.Strings.bufferedEventsKey) as? Data {
            let jsonDecoder = JSONDecoder()
            if let bufferedEvents = try? jsonDecoder.decode([String:EventModel].self, from: bufferedEventsData ) {
                return bufferedEvents
            }
        }
        return nil
    }
    
    private func removeEventFromBuffer(eventId: String) {
        if var bufferedEvents = getBufferedEvents() {
            bufferedEvents.removeValue(forKey: eventId)
            //UserDefaults.standard.set(bufferedEvents, forKey: GlobalConstants.Strings.bufferedEventsKey)
            set(codable: bufferedEvents, forKey: GlobalConstants.Strings.bufferedEventsKey)
            
        }
    }
    
    private func set<T:Codable>(codable:T, forKey key:String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(codable) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
}



