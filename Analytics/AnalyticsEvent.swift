//
//  AnalyticsEvent.swift
//  Analytics
//
//  Created by Mohsen on 7/22/20.
//

import Foundation

// AnalyticsEvent, which will contain all the events that our analytics system supports

public protocol EventProtocol {
    var eventName: String { get }
    var attributes: [String:String] { get }
}

struct EventModel: Codable {
    var sessionId : Int!
    var eventTime: String!
    var eventName: String!
    var attributes: String!
}

