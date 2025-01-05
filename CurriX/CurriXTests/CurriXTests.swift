//
//  CurriXTests.swift
//  CurriXTests
//
//  Created by Welkin Y on 3/7/24.
//

import XCTest

@testable import CurriX

final class CurriXTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDownloadAllTerms() async throws {
        
        try await AllTerms.shared.obtainTerms()
        XCTAssertTrue(AllTerms.shared.initialized)
        XCTAssertFalse(AllTerms.shared.terms.isEmpty)
    }
    
    func testDownloadAllSubjects() async throws {
        
        try await AllSubjects.shared.obtainSubjects()
        XCTAssertTrue(AllSubjects.shared.initialized)
        XCTAssertFalse(AllSubjects.shared.subjects.isEmpty)
    }
    
    func testDownloadSearchSubject() async throws {
        try await AllSubjects.shared.obtainSubjects()
        try await _ = downloadCoursesBySubject(AllSubjects.shared.subjects[0])
    }
    
    func testDownloadCoursesDetail() async throws {
//        await AllTerms.shared.waitForInitialization()
//        await AllSubjects.shared.waitForInitialization()
//        await downloadCoursesDetail(strm: 1890, crse:"000081")
        
    }
    
    
    //    func testPerformanceExample() throws {
    //        // This is an example of a performance test case.
    //        measure {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
    
}
