//
//  Class.swift
//  CurriX
//
//  Created by 黄承暄 on 3/10/24.
//

import Foundation
import SwiftData
import SwiftyJSON

enum ComponentType: String, Codable {
    case Lecture
    case Discussion
    case Other
    
    init(_ string: String) {
        switch string {
        case "Lecture":
            self = .Lecture
        case "Discussion":
            self = .Discussion
        default:
            print("Unseen component type \(string)")
            self = .Other
        }
    }
}

final class ClassComponent: CustomStringConvertible, Codable, Identifiable {
    var description: String {
        return "\(type)\n\(meetingPattern?.description ?? "nil")"
    }
    
    var type: ComponentType
    var meetingPattern: ClassMeetingPattern? = nil
    
    init(clsSumJson: [String:Any]) throws {
        guard let typeString = clsSumJson["ssr_component_lov_descr"] as? String else { throw "data invalid\n\(clsSumJson)" }
        self.type = ComponentType(typeString)
        
        if let json = clsSumJson["classes_meeting_patterns"] as? [String:Any],
           let meetPatJson = json["class_meeting_pattern"] as? [String:Any] {
            let meetPat = try ClassMeetingPattern(meetPatJson: meetPatJson)
            self.meetingPattern = meetPat
        } else {
            throw "Class summary json cannot be retrieved\n\(clsSumJson)"
        }
    }
}

final class DukeClass: Codable, Identifiable {
    // Stored Properties
    let classNumber: String
    var termStr: String
    var sessionCode: String
    
    var title: String?
    
    // Course related info
    var courseID: String
    var courseSubject: String? = nil
    var catalogNumber: String? = nil
    var courseOfferNum: String? = nil
    var section: String? = nil
    var descriptionLong: String? = nil
    var components: [ClassComponent] = []
    var career: String? = nil
    var campus: String? = nil
    var consent: String? = nil
    
    var enrollmentCount: Int? = nil
    var enrollmentCap: Int? = nil
    var waitListCount: Int? = nil
    var waitListCap: Int? = nil
    var enrollmentRequirements: String? = nil
    var facility: String? = nil // For Map use
    
    // Static Inits
    static func obtainClasses(json: [String:Any]) throws -> [DukeClass] {
        func classFromSummary(_ summary: [String:Any]) throws -> DukeClass? {
            // Check if component type is Lecture to determine the class number
            if summary["ssr_component_lov_descr"] as? String == "Lecture" {
                guard let srcClsNum = summary["class_nbr"] as? String,
                      let srcSessionCode = summary["session_code"] as? String,
                      let srcCourseID = summary["crse_id"] as? String,
                      let srcTermStr = summary["strm"] as? String,
                      let srcSection = summary["class_section"] as? String,
                      let topic = summary["class_topic"] as? String
                else { throw "Cannot decode class summary" }
                
                let newClass = DukeClass(classNumber: srcClsNum, course: srcCourseID, term: srcTermStr, sessionCode: srcSessionCode)
                let clsComp = try ClassComponent(clsSumJson: summary)
                newClass.components.append(clsComp)
                newClass.section = srcSection
                
                if topic != "0" { newClass.title = topic }
                
                return newClass
            }
            return nil
        }
        // json should be from downloadCoursesDetail
        guard let json = json["ssr_get_classes_resp"] as? [String:Any],
        let json = json["search_result"] as? [String:Any],
        let json = json["subjects"] as? [String:Any],
        let srcSubject = json["subject"] as? [String:Any],
        let json = srcSubject["classes_summary"] as? [String:Any]
        else { throw "Specific course and term combination doesn't exist, maybe this class is not offered in term." }
                
        // classes_summary can be a dictionary or a list
        var res: [DukeClass] = []
        if let clsSum = json["class_summary"] as? [String:Any] {
            // There is only one class in this course
            if let dukeClass = try classFromSummary(clsSum) {
                res.append(dukeClass)
            }
        } else if let clsSums = json["class_summary"] as? [[String:Any]] {
            // There are multiple components or classes in this course
            // Example for multiple components: lecture + discussion
            // Example for multiple classes: "COMPSCI 590 - 01" is on complexity, "COMPSCI 590 - 10" is on generative AI
            for clsSum in clsSums {
                if let dukeClass = try classFromSummary(clsSum) {
                    res.append(dukeClass)
                }
            }
        } else {
            throw "Class summary not a Dict nor List"
        }
        
        if res.count == 0 {
            throw "No lecture summary found"
        } else {
            guard let clsSubject = srcSubject["subject"] as? String,
                  let catalogNumber = srcSubject["catalog_nbr"] as? String,
                  let career = srcSubject["acad_career_lov_descr"] as? String,
                  let crseOfferNum = srcSubject["crse_offer_nbr"] as? String
            else { throw "Course level information cannot be retrieved" }
            for dukeClass in res {
                dukeClass.courseSubject = clsSubject
                dukeClass.catalogNumber = catalogNumber
                dukeClass.career = career
                dukeClass.courseOfferNum = crseOfferNum
            }
            return res
        }
    }
    
    // Initializers
    init(classNumber: String, course: String, term: String, sessionCode: String) {
        self.classNumber = classNumber
        self.courseID = course
        self.termStr = term
        self.sessionCode = sessionCode
    }
    
    // Methods
    func update(json: [String:Any]) throws {
        guard let json = json["ssr_get_class_section_resp"] as? [String:Any],
              let json = json["class_section_result"] as? [String:Any],
              let json = json["class_sections"] as? [String:Any],
              let clsInfo = json["ssr_class_section"] as? [String:Any]
        else { throw "Class info missing" }
        
        if let descriptionLong = clsInfo["descr200"] as? String {
            self.descriptionLong = descriptionLong
        }
        if let campus = clsInfo["campus_lov_descr"] as? String {
            self.campus = campus
        }
        if let consent = clsInfo["consent_lov_descr"] as? String {
            self.consent = consent
        }
        if let enrollmentCount = Int(clsInfo["enrl_tot"] as? String ?? "NotInt") {
            self.enrollmentCount = enrollmentCount
        }
        if let enrollmentCap = Int(clsInfo["enrl_cap"] as? String ?? "NotInt") {
            self.enrollmentCap = enrollmentCap
        }
        if let waitListCount = Int(clsInfo["wait_tot"] as? String ?? "NotInt") {
            self.waitListCount = waitListCount
        }
        if let waitListCap = Int(clsInfo["wait_cap"] as? String ?? "NotInt") {
            self.waitListCap = waitListCap
        }
        if let json = clsInfo["enrollment_details"] as? [String:Any],
           let json = json["enrollment_information"] as? [String:Any],
           let enrollmentRequirements = json["enrollment_requirements"] as? String {
            self.enrollmentRequirements = enrollmentRequirements
        }
    }
}

extension DukeClass: Hashable {
    var identifier: String {
        "\(classNumber) \(termStr) \(sessionCode)"
    }
    
    static func == (lhs: DukeClass, rhs: DukeClass) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
