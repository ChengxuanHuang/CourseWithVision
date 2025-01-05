//
//  Course.swift
//  CurriX
//
//  Created by 黄承暄 on 3/10/24.
//

import Foundation
import SwiftData
import SwiftUI
import UniformTypeIdentifiers

class Course: CustomStringConvertible, Hashable, Identifiable, Codable {
    var identifier: String {
        return "\(courseID) \(courseOfferNum)"
    }
        
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
        
    public static func == (lhs: Course, rhs: Course) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    // Stored Properties
    let courseID: String
    var courseOfferNum: String
    var subject: Subject
    var catalogNumber: String
    var institution: String? = nil
    var courseTitleLong: String? = nil
    var descLong: String? = nil
    var units: String? = nil
    var offeringTerms: [Term] = []
    var termsStr: String? = nil
    var message: String? = nil
    
    // Static Initializers
    static func obtainCourses(json: [String:Any], subject: Subject) -> [Course]? {
        // json should be from downloadCoursesBySubject
        guard let json = json["ssr_get_courses_resp"] as? [String:Any],
              let json = json["course_search_result"] as? [String:Any],
              let json = json["subjects"] as? [String:Any],
              let json = json["subject"] as? [String:Any],
              let json = json["course_summaries"] as? [String:Any],
              let courses = json["course_summary"] as? [[String:Any]]
        else { return nil }
        var res = [Course]()
        
        for course in courses {
            guard let crseID = course["crse_id"] as? String,
                  let courseOfferNum = course["crse_offer_nbr"] as? String,
                  let catalogNumber = course["catalog_nbr"] as? String,
                  let institution = course["institution_lov_descr"] as? String,
                  let courseTitleLong = course["course_title_long"] as? String
            else { return nil }
            
            let newCourse = Course(crse_id: crseID, course_offer_number: courseOfferNum, subject: subject, catalogNumber: catalogNumber)
            newCourse.institution = institution
            newCourse.courseTitleLong = courseTitleLong
            res.append(newCourse)
        }
        
        return res.count == 0 ? nil : res
    }
    
    // Computed Properties
    var description: String {
        "\(subject.code) \(catalogNumber): \(courseID)"
    }
    
    // Initializer(s)
    init(crse_id: String, course_offer_number: String, subject: Subject, catalogNumber: String) {
        self.courseID = crse_id
        self.courseOfferNum = course_offer_number
        self.subject = subject
        self.catalogNumber = catalogNumber
    }
    
    init(rawCourse: RawCourse) {
        courseID = rawCourse.crse_id
        courseOfferNum = rawCourse.crse_offer_nbr!
        subject = Subject(code:rawCourse.subject!, desc:rawCourse.subject_lov_descr!)
        catalogNumber = rawCourse.catalog_nbr!
        courseTitleLong = rawCourse.course_title_long
        termsStr = rawCourse.ssr_crse_typoff_cd
    }
    
    // Methods
    func updateOfferInfo(json: [String:Any]) throws {
        // json should be from downloadCourseOfferInfo
        guard let json = json["ssr_get_course_offering_resp"] as? [String:Any],
              let json = json["course_offering_result"] as? [String:Any],
              let message = json["ssr_crs_gen_msg"] as? String,
              let json = json["course_offering"] as? [String:Any],
              let descr = json["descrlong"] as? String,
              let units = json["units_range"] as? String,
              let termsStr = json["ssr_crse_typoff_cd"] as? String
        else { throw "Missing fields" }
        
        self.message = message
        self.units = units
        self.descLong = descr
        self.termsStr = termsStr
        
        if self.offeringTerms.count != 0 {
            return
        }

        if let json = json["terms_offered"] as? [String:Any], let terms = json["term_offered"] as? [[String:Any]] {
            for term in terms {
                guard let strm = term["strm"] as? String,
                    let newTerm = AllTerms.obtainTerm(termNumber: strm)
                else { return }
                self.offeringTerms.append(newTerm)
            }
        } else {
            self.offeringTerms = []
        }
    }
}

extension UTType {
    static var course: UTType = UTType(exportedAs: "com.ece564.visionpro.course-transferable")
}

extension Course: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .course)
    }
}
