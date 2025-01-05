//
//  ResponseHandler.swift
//  CurriX
//
//  Created by Welkin Y on 3/12/24.
//

import Foundation

protocol ResponseHandler<T> {
    associatedtype T
    func handleResponse(data: Data) throws -> T
}

