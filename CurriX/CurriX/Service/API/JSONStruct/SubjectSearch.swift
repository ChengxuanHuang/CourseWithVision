//
//  SubjectSearch.swift
//  CurriX
//
//  Created by Welkin Y on 3/8/24.
//

import Foundation

// Reference Course Builder
// https://app.quicktype.io/#l=go

// Struct for subject JSON decoder
struct SubjectSearch: Codable{
    let ssr_get_courses_resp: SsrGetCoursesResp
    
    struct SsrGetCoursesResp: Codable {
        let course_search_result: CourseSearchResult
        let xmlns: String
        
        enum CodingKeys: String, CodingKey {
            case xmlns = "@xmlns"
            case course_search_result
        }
    }
    
    struct CourseSearchResult: Codable {
        let ssr_crs_gen_msg: String?
        let ssr_crs_srch_count: String
        let subjects: Subjects
    }
    
    struct Subjects: Codable {
        let subject: Subject
    }
    
    struct Subject: Codable {
        let institution, institution_lov_descr, subject, subject_lov_descr: String
        let subject_crs_count: String
        let course_summaries: CourseSummaries?
    }
    
    struct CourseSummaries: Codable {
        let course_summary: [RawCourse]
    }
}
