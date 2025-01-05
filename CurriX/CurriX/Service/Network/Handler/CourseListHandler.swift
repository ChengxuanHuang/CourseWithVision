//
//  CourseListHandler.swift
//  CurriX
//
//  Created by Welkin Y on 3/13/24.
//

import Foundation
class CourseListHandler: ResponseHandler {
    var parsedData: [RawCourse] = []
    internal func handleResponse(data: Data) throws -> [Course] {
        let json = try JSONDecoder().decode(SubjectSearch.self, from:data)
        parsedData = json.ssr_get_courses_resp.course_search_result.subjects.subject.course_summaries?.course_summary ?? []
        return parsedData.map({ Course(rawCourse: $0) })
    }
}
