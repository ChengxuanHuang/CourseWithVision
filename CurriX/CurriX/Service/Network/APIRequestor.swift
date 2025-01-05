//
//  APIRequestor.swift
//  CurriX
//
//  Created by Welkin Y on 3/8/24.
//

import Foundation
// Reference: sp2023 Course Builder

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

class APIrequestor: ObservableObject{
    static let shared = APIrequestor() //singleton for getting the api requestor
    private init() { }
    @Published var prog: Float = 0.0
    
    func makeDownloadRequest<T>(url: URL?, handler: any ResponseHandler<T>) async throws -> T {
        guard let url = url else {
            logger.error("Url error for looking up fieldnames")
            throw "Some Error"
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "access_token")
        let (data, _) = try await getSession().data(from: url, delegate: nil) // Remove delegate if you are not using one
        return try handler.handleResponse(data: data)
    }
    
    private func getSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config, delegate: nil, delegateQueue: nil)
        return session
    }
}



