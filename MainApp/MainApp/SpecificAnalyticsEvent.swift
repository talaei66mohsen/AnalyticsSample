//
//  SpecificAnalyticsEvent.swift
//  MainApp
//
//  Created by Mohsen on 7/22/20.
//  Copyright © 2020 Mohsen. All rights reserved.
//

import Foundation
import Analytics

enum SpecificAnalyticsEvent: EventProtocol {
    
    case screenViewed(screenViewed: String)
    case screenTapped(location: (Float))
    case valueChanged(value: Float)
    case buttonTapped(buttonSelected: String)
    
    var eventName: String {
        switch self {
        case .screenTapped:
            return "screenTapped"
        case .valueChanged:
            return "valueChanged"
        case .buttonTapped:
            return "buttonTapped"
        case .screenViewed:
            return "screenViewed"
            
        }
    }
    
    var attributes: [String:String] {
        switch self {
        case .screenTapped(let location):
            return ["xAxis" : "\(location)"]
        case .valueChanged(let value):
            return ["current value" : "\(value)"]
        case .buttonTapped(let buttonSelected):
            return ["button name" : buttonSelected]
        case .screenViewed(let viewedController):
            return ["ViewedController" : viewedController]
        }
    }
}

extension SpecificAnalyticsEvent {
    
    private enum CodingKeys: String, CodingKey {
        case screenViewed
        case screenTapped
        case valueChanged
        case buttonTapped
    }
    
    enum SpecificAnalyticsEventCodingError: Error {
        case decoding(String)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let value = try? values.decode(String.self, forKey: .screenViewed) {
            self = .screenViewed(screenViewed: value)
            return
        }
        
        if let value = try? values.decode(Float.self, forKey: .screenTapped) {
            self = .screenTapped(location: value)
            return
        }
        
        if let value = try? values.decode(Float.self, forKey: .valueChanged) {
            self = .valueChanged(value: value)
            return
        }
        
        if let value = try? values.decode(String.self, forKey: .buttonTapped) {
            self = .buttonTapped(buttonSelected: value)
            return
        }
        
        throw SpecificAnalyticsEventCodingError.decoding("Whoops! \(dump(values))")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .screenViewed(let screenViewed):
            try container.encode(screenViewed, forKey: .buttonTapped)
        case .screenTapped(let number):
            try container.encode(number, forKey: .screenTapped)
        case .valueChanged(let value):
            try container.encode(value, forKey: .valueChanged)
        case .buttonTapped(let value):
            try container.encode(value, forKey: .buttonTapped)
            
        }
    }
}
