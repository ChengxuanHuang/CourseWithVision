//
//  URLBuilder.swift
//  CurriX
//
//  Created by Welkin Y on 3/12/24.
//

import Foundation

// let user set their own key? check clipboard function?
let userApiKey = UserDefaults.standard.string(forKey: "UserAPIKEY")
let apiKey = userApiKey ?? "c225ba60116c06dac0347dd958126a21"

class URLBuilder {
//    static func buildURL(forSubject subject: Subject) -> URL? {
//        let subjectStr = "\(subject.code) - \(subject.desc)"
//        let urlString = "https://streamer.oit.duke.edu/curriculum/courses/subject/\(subjectStr)?access_token=\(apiKey)"
//        return URL(string: urlString, encodingInvalidCharacters: true)
//    }
    
    static func buildURL(forSubject subjectCode: String) -> URL? {
        let urlString = "https://streamer.oit.duke.edu/curriculum/courses/subject/\(subjectCode)?access_token=\(apiKey)"
        return URL(string: urlString, encodingInvalidCharacters: true)
    }
    
    static func buildURL(forFieldName fieldName: String) -> URL? {
        let urlString = "https://streamer.oit.duke.edu/curriculum/list_of_values/fieldname/\(fieldName)?access_token=\(apiKey)"
        return URL(string: urlString)
    }
    
    static func buildURL(strm: String, crseID: String, crseOfferNum: String) -> URL? {
        let urlString =  "https://streamer.oit.duke.edu/curriculum/classes/strm/\(strm)/crse_id/\(crseID)?crse_offer_nbr=\(crseOfferNum)&access_token=\(apiKey)"
        return URL(string: urlString)
    }
    
    static func buildURL(crseID: String, crseOfferNum: String) -> URL? {
        let urlString =  "https://streamer.oit.duke.edu/curriculum/courses/crse_id/\(crseID)/crse_offer_nbr/\(crseOfferNum)?access_token=\(apiKey)"
        return URL(string: urlString)
    }
    
    static func buildURL(tgtClass: DukeClass, courseOfferNum: String) -> URL? {
        let sessionCode = tgtClass.sessionCode
        guard let classSection = tgtClass.section
        else {
            print(tgtClass.section)
            return nil
        }
        let urlString =  "https://streamer.oit.duke.edu/curriculum/classes/strm/\(tgtClass.termStr)/crse_id/\(tgtClass.courseID)/crse_offer_nbr/\(courseOfferNum)/session_code/\(sessionCode)/class_section/\(classSection)?access_token=\(apiKey)"
        return URL(string: urlString)
    }
}
