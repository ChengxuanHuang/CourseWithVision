//
//  TermHandler.swift
//  CurriX
//
//  Created by Welkin Y on 3/12/24.
//

import Foundation
import SwiftUI

class TermHandler: ResponseHandler {
    private var parsedData: [FieldName.Value] = []
    internal func handleResponse(data: Data) throws {
        let json = try JSONDecoder().decode(FieldName.self, from:data)
        parsedData = json.sccLovResp.lovs.lov.values.value
        AllTerms.shared.terms = parsedData.map({return Term(code:$0.code, desc:$0.desc)})
        AllTerms.shared.initialized = true
        logger.info("All terms initialized")
    }
}
