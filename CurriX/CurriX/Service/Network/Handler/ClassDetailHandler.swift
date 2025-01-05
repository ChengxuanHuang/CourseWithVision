//
//  ClassDetailHandler.swift
//  CurriX
//
//  Created by 黄承暄 on 3/13/24.
//

import Foundation

class ClassDetailHandler: ResponseHandler {
    func handleResponse(data: Data) throws -> DukeClass {
        let json = try JSONSerialization.jsonObject(with: data) as? [String:Any] ?? [:]
        try dukeClass.update(json: json)
        return dukeClass
    }
    
    let dukeClass: DukeClass
    init(_ dukeClass: DukeClass) {
        self.dukeClass = dukeClass
    }
}

class CourseOfferInfoHandler: ResponseHandler {
    func handleResponse(data: Data) throws -> Course {
        let json = try JSONSerialization.jsonObject(with: data) as? [String:Any] ?? [:]
        try course.updateOfferInfo(json: json)
        return course
    }
    
    let course: Course
    init(_ course: Course) {
        self.course = course
    }
}

