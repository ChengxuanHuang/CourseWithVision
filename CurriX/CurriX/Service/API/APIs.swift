//
//  APIs.swift
//  CurriX
//
//  Created by Welkin Y on 3/12/24.
//

import Foundation


func downloadAllTerms() async throws {
    let url = URLBuilder.buildURL(forFieldName: "STRM")
    logger.debug("Download terms from:\(url as Any)")
    let handler = TermHandler()
    try await APIrequestor.shared.makeDownloadRequest(url: url, handler: handler)
}

func downloadAllSubjects() async throws {
    let url = URLBuilder.buildURL(forFieldName: "SUBJECT")
    logger.debug("Download subjects from:\(url as Any)")
    let handler = SubjectHandler()
    try await APIrequestor.shared.makeDownloadRequest(url: url, handler: handler)
}

func downloadCoursesBySubject(_ subject: Subject) async throws -> [Course] {
    let url = URLBuilder.buildURL(forSubject: subject.code)
    logger.debug("Download \(subject.code) courses from:\(url as Any)")
    let handler = CourseListHandler()
    return try await APIrequestor.shared.makeDownloadRequest(url: url, handler: handler)
}

func downloadCoursesBySubject(_ subjectCode: String) async throws -> [Course] {
    let url = URLBuilder.buildURL(forSubject: subjectCode)
    logger.debug("Download \(subjectCode) courses from:\(url as Any)")
    let handler = CourseListHandler()
    return try await APIrequestor.shared.makeDownloadRequest(url: url, handler: handler)
}

func downloadCourseDetail(strm: Term, crse: Course) async throws -> [DukeClass] {
    let url = URLBuilder.buildURL(strm: strm.termNumber, crseID: crse.courseID, crseOfferNum: crse.courseOfferNum)
    logger.debug("Download course \(crse.courseID) from:\(url as Any)")
    let handler = CourseDetailHandler()
    return try await APIrequestor.shared.makeDownloadRequest(url: url, handler: handler)
}

func downloadAllCourseDetail(strm: Term, courses: [Course]) async throws -> [Course:[DukeClass]] {
    try await withThrowingTaskGroup(of: (Course, [DukeClass]).self) { group in
        for course in courses {
            group.addTask {
                (course, try await downloadCourseDetail(strm: strm, crse: course))
            }
        }
        let dictionary = try await group.reduce(into: [:]) { $0[$1.0] = $1.1 }
        return dictionary
    }
}

func downloadCourseDetail(strmStr: String, crseId: String, crseOfferNum: String) async throws -> [DukeClass] {
    let url = URLBuilder.buildURL(strm: strmStr, crseID: crseId, crseOfferNum: crseOfferNum)
    logger.debug("Download course \(crseId) from:\(url as Any)")
    let handler = CourseDetailHandler()
    return try await APIrequestor.shared.makeDownloadRequest(url: url, handler: handler)
}

// func downloadCourseOverview(crse: Course) async throws -> [DukeClass] {
//     let url = URLBuilder.buildURL(crseID: crse.courseID, crseOfferNum: crse.courseOfferNum)
//     logger.debug("Download course \(crse.courseID) from:\(url as Any)")
//     let handler = CourseDetailHandler()
//     return try await APIrequestor.shared.makeDownloadRequest(url: url, handler: handler)
// }

func downloadCourseOfferInfo(_ course: Course) async throws -> Course {
    let url = URLBuilder.buildURL(crseID: "\(course.courseID)", crseOfferNum: "\(course.courseOfferNum)")
    logger.debug("Download \(course.courseID) course from:\(url as Any)")
    let handler = CourseOfferInfoHandler(course)
    return try await APIrequestor.shared.makeDownloadRequest(url: url, handler: handler)
}

func downloadClassDetail(dukeClass: DukeClass) async throws -> DukeClass {
    guard let offerNum = dukeClass.courseOfferNum else {
        throw "Offer number is nil for dukeClass \(dukeClass)"
    }
    let url = URLBuilder.buildURL(tgtClass: dukeClass, courseOfferNum: offerNum)
    logger.debug("Download class \(String(describing: dukeClass.classNumber)) from:\(url as Any)")
    let handler = ClassDetailHandler(dukeClass)
    return try await APIrequestor.shared.makeDownloadRequest(url: url, handler: handler)
}
