//
//  CourseDetailHandler.swift
//  CurriX
//
//  Created by Welkin Y on 3/12/24.
//

import Foundation

class CourseDetailHandler: ResponseHandler {
    func handleResponse(data: Data) throws -> [DukeClass] {
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String:Any]
        else {
            throw "Cannot decode json"
        }
        let res = try DukeClass.obtainClasses(json: json)
        return res
    }
}
