//
//  Helper.swift
//  OIL_APP
//
//  Created by cdt307 on 5/8/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//

import UIKit

class Helper: NSObject {
    static func timeAgoStringFromDate(date: Date) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        
        let now = Date()
        
        let calendar = NSCalendar.current
        let components1: Set<Calendar.Component> = [.year, .month, .weekOfMonth, .day, .hour, .minute, .second]
        
        var components = calendar.dateComponents(components1, from: now, to: date)
        
        if(now > date){
            components = calendar.dateComponents(components1, from: date, to: now)
        }
        
        if components.year ?? 0 > 0 {
            formatter.allowedUnits = .year
        } else if components.month ?? 0 > 0 {
            formatter.allowedUnits = .month
        } else if components.weekOfMonth ?? 0 > 0 {
            formatter.allowedUnits = .weekOfMonth
        } else if components.day ?? 0 > 0 {
            formatter.allowedUnits = .day
        } else if components.hour ?? 0 > 0 {
            formatter.allowedUnits = [.hour]
        } else if components.minute ?? 0 > 0 {
            formatter.allowedUnits = .minute
        } else {
            formatter.allowedUnits = .second
        }
        
        var formatString = NSLocalizedString("%@ left", comment: "Used to say how much time has passed. e.g. '2 hours ago'")
        
        if(now > date){
            formatString = NSLocalizedString("%@ ago", comment: "Used to say how much time has passed. e.g. '2 hours ago'")
        }
        
        guard let timeString = formatter.string(for: components) else {
            return nil
        }
        return String(format: formatString, timeString)
    }
}
