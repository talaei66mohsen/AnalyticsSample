//
//  NetworkResponse.swift
//  Analytics
//
//  Created by Mohsen on 7/23/20.
//

import Foundation

enum NetworkResponse<T> {
    case success(value:T)
    case failure(message: String)
}
