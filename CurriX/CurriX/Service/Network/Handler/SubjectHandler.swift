//
//  SubjectHandler.swift
//  CurriX
//
//  Created by Welkin Y on 3/12/24.
//

import Foundation

class SubjectHandler: ResponseHandler {
    private var parsedData: [FieldName.Value] = []
    internal func handleResponse(data: Data) throws {
        let json = try JSONDecoder().decode(FieldName.self, from:data)
        parsedData = json.sccLovResp.lovs.lov.values.value
        AllSubjects.shared.initialized = true
        AllSubjects.shared.subjects = parsedData.map({return Subject(code:$0.code, desc:$0.desc)})
        logger.info("All subjects initialized")
    }
}

