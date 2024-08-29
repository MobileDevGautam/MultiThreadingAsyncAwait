//
//  CurrentDate.swift
//  GettingStartedAsyncAwait
//
//  Created by GAUTAM TIWARI on 30/08/24.
//

import Foundation

struct CurrentDate: Decodable, Identifiable {
    let id = UUID()
    let date: String
    
    private enum CodingKeys: String, CodingKey {
        case date = "date"
    }
}
