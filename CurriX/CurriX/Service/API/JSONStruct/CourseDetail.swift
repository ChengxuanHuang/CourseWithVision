//
//  CourseDetail.swift
//  CurriX
//
//  Created by Welkin Y on 3/13/24.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let courseDetail = try? JSONDecoder().decode(CourseDetail.self, from: jsonData)

import Foundation

// MARK: - CourseDetail
struct CourseDetail: Codable {
    var ssrGetClassesResp: SsrGetClassesResp

    enum CodingKeys: String, CodingKey {
        case ssrGetClassesResp = "ssr_get_classes_resp"
    }
    
    // MARK: - SsrGetClassesResp
    struct SsrGetClassesResp: Codable {
        var searchResult: SearchResult
        var xmlns: String

        enum CodingKeys: String, CodingKey {
            case searchResult = "search_result"
            case xmlns = "@xmlns"
        }
    }

    // MARK: - SearchResult
    struct SearchResult: Codable {
        var errorWarnText: String?
        var ssrCourseCount: String
        var ssrErrLmtExceed, ssrWrnLmtExceed: String?
        var ssrClassCount: String
        var subjects: Subjects

        enum CodingKeys: String, CodingKey {
            case errorWarnText = "error_warn_text"
            case ssrCourseCount = "ssr_course_count"
            case ssrErrLmtExceed = "ssr_err_lmt_exceed"
            case ssrWrnLmtExceed = "ssr_wrn_lmt_exceed"
            case ssrClassCount = "ssr_class_count"
            case subjects
        }
    }

    // MARK: - Subjects
    struct Subjects: Codable {
        var subject: [Subject]
    }

    // MARK: - Subject
    struct Subject: Codable {
        var crseId, crseIdLovDescr, subject, subjectLovDescr: String
        var catalogNbr, institution, institutionLovDescr, acadCareer: String
        var acadCareerLovDescr, courseTitleLong, crseOfferNbr: String
        var classesSummary: ClassesSummary

        enum CodingKeys: String, CodingKey {
            case crseId = "crse_id"
            case crseIdLovDescr = "crse_id_lov_descr"
            case subject
            case subjectLovDescr = "subject_lov_descr"
            case catalogNbr = "catalog_nbr"
            case institution
            case institutionLovDescr = "institution_lov_descr"
            case acadCareer = "acad_career"
            case acadCareerLovDescr = "acad_career_lov_descr"
            case courseTitleLong = "course_title_long"
            case crseOfferNbr = "crse_offer_nbr"
            case classesSummary = "classes_summary"
        }
    }

    // MARK: - ClassesSummary
    struct ClassesSummary: Codable {
        var classSummary: ClassSummary

        enum CodingKeys: String, CodingKey {
            case classSummary = "class_summary"
        }
    }

    // MARK: - ClassSummary
    struct ClassSummary: Codable {
        var crseId, crseIdLovDescr, subject, subjectLovDescr: String
        var catalogNbr, crseOfferNbr, strm, strmLovDescr: String
        var sessionCode, sessionCodeLovDescr, classSection, classNbr: String
        var schedulePrint, schedulePrintLovDescr, combinedSection, combinedSectionLovDescr: String
        var status: [String]
        var classTopic: String
        var ssrClassnameLong: String?
        var statusLovDescr, ssrComponent, ssrComponentLovDescr, campus: String
        var campusLovDescr, institution, ssrDescrlong, instructionMode: String
        var instructionModeLovDescr: String
        var classesMeetingPatterns: ClassesMeetingPatterns

        enum CodingKeys: String, CodingKey {
            case crseId = "crse_id"
            case crseIdLovDescr = "crse_id_lov_descr"
            case subject
            case subjectLovDescr = "subject_lov_descr"
            case catalogNbr = "catalog_nbr"
            case crseOfferNbr = "crse_offer_nbr"
            case strm
            case strmLovDescr = "strm_lov_descr"
            case sessionCode = "session_code"
            case sessionCodeLovDescr = "session_code_lov_descr"
            case classSection = "class_section"
            case classNbr = "class_nbr"
            case schedulePrint = "schedule_print"
            case schedulePrintLovDescr = "schedule_print_lov_descr"
            case combinedSection = "combined_section"
            case combinedSectionLovDescr = "combined_section_lov_descr"
            case status
            case classTopic = "class_topic"
            case ssrClassnameLong = "ssr_classname_long"
            case statusLovDescr = "status_lov_descr"
            case ssrComponent = "ssr_component"
            case ssrComponentLovDescr = "ssr_component_lov_descr"
            case campus
            case campusLovDescr = "campus_lov_descr"
            case institution
            case ssrDescrlong = "ssr_descrlong"
            case instructionMode = "instruction_mode"
            case instructionModeLovDescr = "instruction_mode_lov_descr"
            case classesMeetingPatterns = "classes_meeting_patterns"
        }
    }

    // MARK: - ClassesMeetingPatterns
    struct ClassesMeetingPatterns: Codable {
        var classMeetingPattern: ClassMeetingPattern

        enum CodingKeys: String, CodingKey {
            case classMeetingPattern = "class_meeting_pattern"
        }
    }

    // MARK: - ClassMeetingPattern
    struct ClassMeetingPattern: Codable {
        var crseId, crseOfferNbr, strm, sessionCode: String
        var sessionCodeLovDescr, classSection, classMtgNbr, facilityId: String
        var facilityIdLovDescr, meetingTimeStart, meetingTimeEnd, mon: String
        var tues, wed, thurs, fri: String
        var sat, sun, startDt, endDt: String
        var crsTopicId: String
        var crsTopicIdLovDescr, descr: String?
        var stndMtgPat, bldgCd, sccLatitude, sccLongitude: String
        var ssrMtgSchedLong, ssrMtgLocLong, ssrInstrLong, ssrMtgDtLong: String
        var ssrTopicLong: String
        var classInstructors: ClassInstructors

        enum CodingKeys: String, CodingKey {
            case crseId = "crse_id"
            case crseOfferNbr = "crse_offer_nbr"
            case strm
            case sessionCode = "session_code"
            case sessionCodeLovDescr = "session_code_lov_descr"
            case classSection = "class_section"
            case classMtgNbr = "class_mtg_nbr"
            case facilityId = "facility_id"
            case facilityIdLovDescr = "facility_id_lov_descr"
            case meetingTimeStart = "meeting_time_start"
            case meetingTimeEnd = "meeting_time_end"
            case mon, tues, wed, thurs, fri, sat, sun
            case startDt = "start_dt"
            case endDt = "end_dt"
            case crsTopicId = "crs_topic_id"
            case crsTopicIdLovDescr = "crs_topic_id_lov_descr"
            case descr
            case stndMtgPat = "stnd_mtg_pat"
            case bldgCd = "bldg_cd"
            case sccLatitude = "scc_latitude"
            case sccLongitude = "scc_longitude"
            case ssrMtgSchedLong = "ssr_mtg_sched_long"
            case ssrMtgLocLong = "ssr_mtg_loc_long"
            case ssrInstrLong = "ssr_instr_long"
            case ssrMtgDtLong = "ssr_mtg_dt_long"
            case ssrTopicLong = "ssr_topic_long"
            case classInstructors = "class_instructors"
        }
    }

    // MARK: - ClassInstructors
    struct ClassInstructors: Codable {
        var classInstructor: ClassInstructor

        enum CodingKeys: String, CodingKey {
            case classInstructor = "class_instructor"
        }
    }

    // MARK: - ClassInstructor
    struct ClassInstructor: Codable {
        var crseId, crseOfferNbr, strm, strmLovDescr: String
        var sessionCode, classSection, classMtgNbr, emplid: String
        var instrRole, instrRoleLovDescr, schedPrintInstr, schedPrintInstrLovDescr: String
        var nameDisplay, lastName, firstName, encryptedEmplid: String

        enum CodingKeys: String, CodingKey {
            case crseId = "crse_id"
            case crseOfferNbr = "crse_offer_nbr"
            case strm
            case strmLovDescr = "strm_lov_descr"
            case sessionCode = "session_code"
            case classSection = "class_section"
            case classMtgNbr = "class_mtg_nbr"
            case emplid
            case instrRole = "instr_role"
            case instrRoleLovDescr = "instr_role_lov_descr"
            case schedPrintInstr = "sched_print_instr"
            case schedPrintInstrLovDescr = "sched_print_instr_lov_descr"
            case nameDisplay = "name_display"
            case lastName = "last_name"
            case firstName = "first_name"
            case encryptedEmplid = "encrypted_emplid"
        }
    }
}



