//
//  DownloadDelegator.swift
//  CurriX
//
//  Created by Welkin Y on 3/12/24.
//

import Foundation
import SwiftUI

class DownloadDelegator: NSObject, URLSessionDownloadDelegate {
    private var handler: (any ResponseHandler)?
    
    init(_ handler: any ResponseHandler) {
        self.handler = handler
    }
    
    internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async {
            APIrequestor.shared.prog = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        }
    }
    
    internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let error = downloadTask.error {
            logger.error("Download failed: \(error)")
            return
        }
        guard let response = downloadTask.response as? HTTPURLResponse else {
            logger.error("Invalid HTTP Response")
            return
        }
        if response.statusCode == 200 {
            if let data: Data = try? Data(contentsOf: location) {
                logger.info("Downloded size: \(data)")
                Task {
                    try handler?.handleResponse(data: data)
                }
            } else {
                logger.error("Unable to read data from \(location)")
                return
            }
        } else {
            logger.error("HTTP error: \(response.statusCode)")
            return
        }
    }
}
