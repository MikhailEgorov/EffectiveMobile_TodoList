//
//  DateFormatter.swift
//  EffectiveMobile_TodoList
//
//  Created by Егоров Михаил on 16.02.2026.
//

import Foundation

extension DateFormatter {
    
    static let todoCellFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    static let todoDetailsFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}
