//
//  ClassMeetingPattern.swift
//  CurriX
//
//  Created by 黄承暄 on 3/10/24.
//

import Foundation
import SwiftData


enum Days: String, Codable, CaseIterable {
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday

    var shorthand: String {
        switch self {
        case .Monday: return "Mon"
        case .Tuesday: return "Tue"
        case .Wednesday: return "Wed"
        case .Thursday: return "Thu"
        case .Friday: return "Fri"
        }
    }
}

class ClassMeetingPattern: CustomStringConvertible, Codable {
    var description: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        let days = "\(days.map{$0.rawValue}.joined(separator: ", "))"
        if let startTime, let endTime {
            return "\(days) \(dateFormatter.string(from: startTime)) - \(dateFormatter.string(from: endTime))"
        }
        return days
    }
    
    var facilityID: String? = nil
    var facilityLongDescript: String? = nil
    var days: [Days] = []
    var startTime: Date? = nil
    var endTime: Date? = nil
    var instructors: [String] = []
    var latitude: String? = nil
    var longitude: String? = nil
    
    init(meetPatJson: [String:Any]) throws {
        guard let facID = meetPatJson["facility_id"] as? String,
              let facLongDesc = meetPatJson["facility_id_lov_descr"] as? String,
              let dayTimeInfo = meetPatJson["ssr_mtg_sched_long"] as? String,
              let latitude = meetPatJson["scc_latitude"] as? String,
              let longitude = meetPatJson["scc_longitude"] as? String
        else { throw "Cannot decode facility info and day time info" }
        
        // Obtain instructor info
        if let instructors = meetPatJson["class_instructors"] as? [String:Any] {
            if let instructor = instructors["class_instructor"] as? [String:Any] {
                if let instructorName = instructor["name_display"] as? String {
                    self.instructors.append(instructorName)
                }
            } else if let instructors = instructors["class_instructor"] as? [[String:Any]] {
                for instructor in instructors {
                    if let instructorName = instructor["name_display"] as? String {
                        self.instructors.append(instructorName)
                    }
                }
            }
        }
        
        self.facilityID = facID
        self.facilityLongDescript = facLongDesc
        (self.days, (self.startTime, self.endTime)) = ClassMeetingPattern.obtainDateTimeInfo(dayTimeInfo)
        self.latitude = latitude
        self.longitude = longitude
    }
    
    static func convertStringTime(_ string: String) -> String? {
        // Convert string like 4:40PM to 16:40
        let last2 = String(string.suffix(2))
        let rawTime = String(string.dropLast(2))
        let times = rawTime.split(separator: ":")
        guard times.count == 2 else { return nil }
        guard var hour = Int(times[0]) else { return nil }
        
        if hour < 12 && last2 == "PM" { hour += 12 }
        return "\(hour):\(times[1])"
    }
    
    static func obtainDateTimeInfo(_ dayTimeInfo: String) -> (days: [Days], (startTime: Date?, endTime: Date?)) {
        // Example: "MW 4:40PM - 5:55PM"
        let splitted = dayTimeInfo.split(separator: " ")
        if splitted.count < 3 {
            return ([], (nil, nil))
        }
        let daysString = splitted[0]; var startTimeString = String(splitted[1]); var endTimeString = String(splitted[3])
        
        var days: [Days] = []
        var prevIsT = false
        daysString.forEach { dayChar in
            switch dayChar {
            case "M":
                days.append(.Monday)
                if prevIsT { days.append(.Tuesday) }
                prevIsT = false
            case "T":
                prevIsT = true
            case "W":
                days.append(.Wednesday)
                if prevIsT { days.append(.Tuesday) }
                prevIsT = false
            case "u":
                if prevIsT { days.append(.Tuesday) }
                prevIsT = false
            case "h":
                if prevIsT { days.append(.Thursday) }
                prevIsT = false
            case "F":
                days.append(.Friday)
                if prevIsT { days.append(.Tuesday) }
                prevIsT = false
            default:
                break
            }
        }
        
        startTimeString = convertStringTime(startTimeString) ?? "NotATime"
        endTimeString = convertStringTime(endTimeString) ?? "NotATime"
        
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(abbreviation: "UTC")

        return (days, (formatter.date(from: startTimeString), formatter.date(from: endTimeString)))
    }
}
