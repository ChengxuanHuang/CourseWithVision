//
//  Subjects.swift
//  CurriX
//
//  Created by 黄承暄 on 3/10/24.
//

import Foundation

struct SubjectJona {
    var abbrev, desc: String
    
    init?(json: [String: String]) {
        guard let code = json["code"],
              let desc = json["desc"]
        else {
            return nil
        }
        self.abbrev = code
        self.desc = desc
    }
}

class AllSubjects {
    // Make class a singleton
    static var shared = AllSubjects()
    
    private init() {
        obtainSubjects()
    }
    
    func obtainSubjects() {
        print("Start obtain subjects")
        let url = URL(string: "https://streamer.oit.duke.edu/curriculum/list_of_values/fieldname/SUBJECT")
        var urlRequest = URLRequest(url: url!)

        urlRequest.httpMethod = "GET"
        
        var task: URLSessionTask? = nil
        
        task = URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            defer { self.sem.signal() }
            self.subjects = self.dataToSubjects(data)
            self.initialized = self.subjects.count != 0
//            DispatchQueue.main.async {
//                self.subjects = self.dataToSubjects(data)
//                self.initialized = self.subjects.count != 0
//            }
        }
        
        task?.resume()
        self.sem.wait()
    }
    
    func dataToSubjects(_ data: Data?) -> [SubjectJona] {
        guard let data = data else { return [] }
        // Serialize the data
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return []
        }
        // Unpack the information
        guard let json = json["scc_lov_resp"] as? [String: Any] else { return [] }
        guard let json = json["lovs"] as? [String: Any] else { return [] }
        guard let json = json["lov"] as? [String: Any] else { return [] }
        guard let json = json["values"] as? [String: Any] else { return [] }
        guard let json = json["value"] as? [[String: String]] else { return [] }
        
        // Obtain results
        var res: [SubjectJona] = []
        for subject in json {
            if let subject = SubjectJona(json: subject) {
                res.append(subject)
                subjectDicts[subject.abbrev] = subject
            }
        }
        
        return res
    }
    
    // Properties
    var initialized: Bool = false
    var subjects: [SubjectJona] = []
    var subjectDicts: [String:SubjectJona] = [:]
    let sem = DispatchSemaphore.init(value: 0)
}


