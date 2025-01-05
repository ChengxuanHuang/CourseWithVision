//
//  Course.swift
//  CurriX
//
//  Created by 黄承暄 on 3/10/24.
//

import Foundation
import SwiftData

class CourseComponent {
    
}

// @Model
class Course : CustomStringConvertible {
    // Stored Properties
    // @Attribute(.unique) let courseID: Int
    let courseID: Int
    var courseOfferNum: Int
    var subject: SubjectJona
    var catalogNumber: String
    var institution: String? = nil
    var courseTitleLong: String? = nil
    var descLong: String? = nil
    var units: Int? = nil
    var courseComponents: [CourseComponent]? = nil
    var offeringTerms: [Term]? = nil
    // TODO: Optional one we can add later
    // Attributes of classes
    
    // Computed Properties
    var description: String {
        // TODO: add description
        "\(subject.abbrev) \(catalogNumber): \(courseID)"
    }
    
    // Initializer(s)
    init(crse_id: Int, course_offer_number: Int, subject: SubjectJona, catalogNumber: String) {
        self.courseID = crse_id
        self.courseOfferNum = course_offer_number
        self.subject = subject
        self.catalogNumber = catalogNumber
    }
    
    init?(json: [String: Any]) {
        guard let courseID = json["crse_id"] as? String,
              let courseOfferNum = json["crse_offer_nbr"] as? String,
              let subjectString = json["subject"] as? String,
              let catalogNumber = json["catalog_nbr"] as? String
        else {
            print("Unpack json failed, json:\n\(json)")
            return nil
        }
        guard let subject = AllSubjects.shared.subjectDicts[subjectString] else {
            print("Subject cannot be found: \(subjectString)")
            return nil
        }
        guard let courseID = Int(courseID),
              let courseOfferNum = Int(courseOfferNum)
        else {
            return nil
        }
        
        self.courseID = courseID
        self.courseOfferNum = courseOfferNum
        self.subject = subject
        self.catalogNumber = catalogNumber
    }
}

func obtainCoursesFor(subject: SubjectJona) {
    let url = URL(string: "https://streamer.oit.duke.edu/curriculum/courses/subject/\(subject.abbrev) - \(subject.desc)?access_token=\(Config.key)", encodingInvalidCharacters: true)
    var urlRequest = URLRequest(url: url!)

    urlRequest.httpMethod = "GET"
    
    var task: URLSessionTask? = nil
    
    task = URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
        _ = dataToCourses(data)
    }
    
    task?.resume()
}

func dataToCourses(_ data: Data?) -> [Course] {
    guard let data = data else { return [] }
    // Serialize the data
    guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
        return []
    }
    // Unpack the information
    guard let json = json["ssr_get_courses_resp"] as? [String: Any] else { return [] }
    guard let json = json["course_search_result"] as? [String: Any] else { return [] }
    guard let json = json["subjects"] as? [String: Any] else { return [] }
    guard let json = json["subject"] as? [String: Any] else { return [] }
    guard let json = json["course_summaries"] as? [String: Any] else { return [] }
    guard let json = json["course_summary"] as? [[String: Any]] else { return [] }
    
    // Obtain results
    var res: [Course] = []
    for course in json {
        if let course = Course(json: course) {
            res.append(course)
            print(course)
        }
    }
    return res
}

// Course offer numbers are for courses that appears in different subjects.
// An example is THEATRST 224 and AAAS 203. Both are the same course from different subjects.
