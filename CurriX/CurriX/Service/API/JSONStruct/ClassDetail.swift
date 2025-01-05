//
//  ClassDetail.swift
//  CurriX
//
//  Created by 黄承暄 on 3/14/24.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let sourceDukeClass = try? JSONDecoder().decode(SourceDukeClass.self, from: jsonData)

import Foundation

// MARK: - SourceDukeClass
struct SourceDukeClass: Codable {
    let ssrGetClassSectionResp: SsrGetClassSectionResp?

    enum CodingKeys: String, CodingKey {
        case ssrGetClassSectionResp = "ssr_get_class_section_resp"
    }
    
    // MARK: - SsrGetClassSectionResp
    struct SsrGetClassSectionResp: Codable {
        let classSectionResult: ClassSectionResult?
        let xmlns: String?

        enum CodingKeys: String, CodingKey {
            case classSectionResult = "class_section_result"
            case xmlns = "@xmlns"
        }
    }

    // MARK: - ClassSectionResult
    struct ClassSectionResult: Codable {
        let ssrCRSSrchCount: String?
        let ssrCRSGenMsg: String?
        let classSections: ClassSections?

        enum CodingKeys: String, CodingKey {
            case ssrCRSSrchCount = "ssr_crs_srch_count"
            case ssrCRSGenMsg = "ssr_crs_gen_msg"
            case classSections = "class_sections"
        }
    }

    // MARK: - ClassSections
    struct ClassSections: Codable {
        let ssrClassSection: SsrClassSection?

        enum CodingKeys: String, CodingKey {
            case ssrClassSection = "ssr_class_section"
        }
    }

    // MARK: - SsrClassSection
    struct SsrClassSection: Codable {
        let acadCareer, acadCareerLovDescr, associatedClass, availableSeats: String?
        let campus, campusLovDescr, catalogNbr, classNbr: String?
        let classSection, classType, classTypeLovDescr: String?
        let combinedSection, combinedSectionLovDescr: String?
        let consent, consentLovDescr, crsTopicID, crsTopicDescr: String?
        let crseID, crseIDLovDescr, crseOfferNbr, descr200: String?
        let descrlong: String?
        let effdt, endDt, enrlCap, enrlStat: String?
        let enrlStatusDescr, enrlTot, gradingBasis, gradingBasisLovDescr: String?
        let institution, institutionLovDescr, instructionMode, instructionModeLovDescr: String?
        let location, locationDescr, minEnrl, printTopic: String?
        let schedulePrint, schedulePrintLovDescr, sessionCode, sessionCodeLovDescr: String?
        let ssrClassnoteLong: String?
        let ssrComponent, ssrComponentLovDescr, ssrCrseAttrLong, ssrCrseTypoffCD: String?
        let ssrDateLong, ssrDropConsent, ssrDropConsentLovDescr: String?
        let ssrGblNoteLong: String?
        let ssrRequisiteLong, startDt, strm, strmLovDescr: String?
        let subject, subjectLovDescr, unitsRange, waitTot: String?
        let waitCap, courseTitleLong, studentLanguage, shift: String?
        let ukLevel, studentGrouping: String?
        let classCombinedSection: String?
        let classComponents: ClassComponents?
        let classMeetingPatterns: ClassMeetingPatterns?
        let classTextBooks: ClassTextBooks?
        let enrollmentDetails: EnrollmentDetails?

        enum CodingKeys: String, CodingKey {
            case acadCareer = "acad_career"
            case acadCareerLovDescr = "acad_career_lov_descr"
            case associatedClass = "associated_class"
            case availableSeats = "available_seats"
            case campus
            case campusLovDescr = "campus_lov_descr"
            case catalogNbr = "catalog_nbr"
            case classNbr = "class_nbr"
            case classSection = "class_section"
            case classType = "class_type"
            case classTypeLovDescr = "class_type_lov_descr"
            case combinedSection = "combined_section"
            case combinedSectionLovDescr = "combined_section_lov_descr"
            case consent
            case consentLovDescr = "consent_lov_descr"
            case crsTopicID = "crs_topic_id"
            case crsTopicDescr = "crs_topic_descr"
            case crseID = "crse_id"
            case crseIDLovDescr = "crse_id_lov_descr"
            case crseOfferNbr = "crse_offer_nbr"
            case descr200, descrlong, effdt
            case endDt = "end_dt"
            case enrlCap = "enrl_cap"
            case enrlStat = "enrl_stat"
            case enrlStatusDescr = "enrl_status_descr"
            case enrlTot = "enrl_tot"
            case gradingBasis = "grading_basis"
            case gradingBasisLovDescr = "grading_basis_lov_descr"
            case institution
            case institutionLovDescr = "institution_lov_descr"
            case instructionMode = "instruction_mode"
            case instructionModeLovDescr = "instruction_mode_lov_descr"
            case location
            case locationDescr = "location_descr"
            case minEnrl = "min_enrl"
            case printTopic = "print_topic"
            case schedulePrint = "schedule_print"
            case schedulePrintLovDescr = "schedule_print_lov_descr"
            case sessionCode = "session_code"
            case sessionCodeLovDescr = "session_code_lov_descr"
            case ssrClassnoteLong = "ssr_classnote_long"
            case ssrComponent = "ssr_component"
            case ssrComponentLovDescr = "ssr_component_lov_descr"
            case ssrCrseAttrLong = "ssr_crse_attr_long"
            case ssrCrseTypoffCD = "ssr_crse_typoff_cd"
            case ssrDateLong = "ssr_date_long"
            case ssrDropConsent = "ssr_drop_consent"
            case ssrDropConsentLovDescr = "ssr_drop_consent_lov_descr"
            case ssrGblNoteLong = "ssr_gbl_note_long"
            case ssrRequisiteLong = "ssr_requisite_long"
            case startDt = "start_dt"
            case strm
            case strmLovDescr = "strm_lov_descr"
            case subject
            case subjectLovDescr = "subject_lov_descr"
            case unitsRange = "units_range"
            case waitTot = "wait_tot"
            case waitCap = "wait_cap"
            case courseTitleLong = "course_title_long"
            case studentLanguage = "student_language"
            case shift
            case ukLevel = "uk_level"
            case studentGrouping = "student_grouping"
            case classCombinedSection = "class_combined_section"
            case classComponents = "class_components"
            case classMeetingPatterns = "class_meeting_patterns"
            case classTextBooks = "class_text_books"
            case enrollmentDetails = "enrollment_details"
        }
    }

    // MARK: - ClassComponents
    struct ClassComponents: Codable {
        let classComponent: SourceClassComponent?

        enum CodingKeys: String, CodingKey {
            case classComponent = "class_component"
        }
    }

    // MARK: - ClassComponent
    struct SourceClassComponent: Codable {
        let ssrComponent, ssrComponentLovDescr, optionalSection, optionalSectionLovDescr: String?
        let classComponentSections: String?

        enum CodingKeys: String, CodingKey {
            case ssrComponent = "ssr_component"
            case ssrComponentLovDescr = "ssr_component_lov_descr"
            case optionalSection = "optional_section"
            case optionalSectionLovDescr = "optional_section_lov_descr"
            case classComponentSections = "class_component_sections"
        }
    }

    // MARK: - ClassMeetingPatterns
    struct ClassMeetingPatterns: Codable {
        let classMeetingPattern: SourceClassClassMettingPattern?

        enum CodingKeys: String, CodingKey {
            case classMeetingPattern = "class_meeting_pattern"
        }
    }

    // MARK: - ClassMeetingPattern
    struct SourceClassClassMettingPattern: Codable {
        let crseID, crseOfferNbr, strm, sessionCode: String?
        let sessionCodeLovDescr, classSection, classMtgNbr, facilityID: String?
        let facilityIDLovDescr, meetingTimeStart, meetingTimeEnd, mon: String?
        let tues, wed, thurs, fri: String?
        let sat, sun, startDt, endDt: String?
        let crsTopicID: String?
        let crsTopicIDLovDescr, descr: String?
        let stndMtgPat, bldgCD, sccLatitude, sccLongitude: String?
        let ssrMtgSchedLong, ssrMtgLOCLong, ssrInstrLong, ssrMtgDtLong: String?
        let ssrTopicLong: String?
        let classInstructors: ClassInstructors?

        enum CodingKeys: String, CodingKey {
            case crseID = "crse_id"
            case crseOfferNbr = "crse_offer_nbr"
            case strm
            case sessionCode = "session_code"
            case sessionCodeLovDescr = "session_code_lov_descr"
            case classSection = "class_section"
            case classMtgNbr = "class_mtg_nbr"
            case facilityID = "facility_id"
            case facilityIDLovDescr = "facility_id_lov_descr"
            case meetingTimeStart = "meeting_time_start"
            case meetingTimeEnd = "meeting_time_end"
            case mon, tues, wed, thurs, fri, sat, sun
            case startDt = "start_dt"
            case endDt = "end_dt"
            case crsTopicID = "crs_topic_id"
            case crsTopicIDLovDescr = "crs_topic_id_lov_descr"
            case descr
            case stndMtgPat = "stnd_mtg_pat"
            case bldgCD = "bldg_cd"
            case sccLatitude = "scc_latitude"
            case sccLongitude = "scc_longitude"
            case ssrMtgSchedLong = "ssr_mtg_sched_long"
            case ssrMtgLOCLong = "ssr_mtg_loc_long"
            case ssrInstrLong = "ssr_instr_long"
            case ssrMtgDtLong = "ssr_mtg_dt_long"
            case ssrTopicLong = "ssr_topic_long"
            case classInstructors = "class_instructors"
        }
    }

    // MARK: - ClassInstructors
    struct ClassInstructors: Codable {
        let classInstructor: ClassInstructor?

        enum CodingKeys: String, CodingKey {
            case classInstructor = "class_instructor"
        }
    }

    // MARK: - ClassInstructor
    struct ClassInstructor: Codable {
        let crseID, crseOfferNbr, strm, strmLovDescr: String?
        let sessionCode, classSection, classMtgNbr, emplid: String?
        let instrRole, instrRoleLovDescr, schedPrintInstr, schedPrintInstrLovDescr: String?
        let nameDisplay, lastName, firstName, encryptedEmplid: String?

        enum CodingKeys: String, CodingKey {
            case crseID = "crse_id"
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

    // MARK: - ClassTextBooks
    struct ClassTextBooks: Codable {
        let classTextBook: ClassTextBook?

        enum CodingKeys: String, CodingKey {
            case classTextBook = "class_text_book"
        }
    }

    // MARK: - ClassTextBook
    struct ClassTextBook: Codable {
        let ssrClsTxbNone, ssrClsTxbStatus, ssrClsTxbStatusLovDescr: String?
        let ssrClsTxbText, textbookMessage: String?
        let ssrClsTxbNoneDescr: String?
        let textBooksDetails: TextBooksDetails?

        enum CodingKeys: String, CodingKey {
            case ssrClsTxbNone = "ssr_cls_txb_none"
            case ssrClsTxbStatus = "ssr_cls_txb_status"
            case ssrClsTxbStatusLovDescr = "ssr_cls_txb_status_lov_descr"
            case ssrClsTxbText = "ssr_cls_txb_text"
            case textbookMessage = "textbook_message"
            case ssrClsTxbNoneDescr = "ssr_cls_txb_none_descr"
            case textBooksDetails = "text_books_details"
        }
    }

    // MARK: - TextBooksDetails
    struct TextBooksDetails: Codable {
        let textBookDetails: TextBookDetails?

        enum CodingKeys: String, CodingKey {
            case textBookDetails = "text_book_details"
        }
    }

    // MARK: - TextBookDetails
    struct TextBookDetails: Codable {
        let ssrCrsematType, ssrCrsematTypeLovDescr, ssrTxbdtlStatus, ssrTxbdtlStatusLovDescr: String?
        let ssrTxbdtlTitle, ssrTxbdtlIsbn, ssrTxbdtlAuthor, ssrTxbdtlPublish: String?
        let ssrTxbdtlEdition, ssrTxbdtlPubyear, currencyCD: String?
        let ssrTxbdtlPrice: String?
        let ssrTxbdtlNotes: String?

        enum CodingKeys: String, CodingKey {
            case ssrCrsematType = "ssr_crsemat_type"
            case ssrCrsematTypeLovDescr = "ssr_crsemat_type_lov_descr"
            case ssrTxbdtlStatus = "ssr_txbdtl_status"
            case ssrTxbdtlStatusLovDescr = "ssr_txbdtl_status_lov_descr"
            case ssrTxbdtlTitle = "ssr_txbdtl_title"
            case ssrTxbdtlIsbn = "ssr_txbdtl_isbn"
            case ssrTxbdtlAuthor = "ssr_txbdtl_author"
            case ssrTxbdtlPublish = "ssr_txbdtl_publish"
            case ssrTxbdtlEdition = "ssr_txbdtl_edition"
            case ssrTxbdtlPubyear = "ssr_txbdtl_pubyear"
            case currencyCD = "currency_cd"
            case ssrTxbdtlPrice = "ssr_txbdtl_price"
            case ssrTxbdtlNotes = "ssr_txbdtl_notes"
        }
    }

    // MARK: - EnrollmentDetails
    struct EnrollmentDetails: Codable {
        let enrollmentInformation: EnrollmentInformation?

        enum CodingKeys: String, CodingKey {
            case enrollmentInformation = "enrollment_information"
        }
    }

    // MARK: - EnrollmentInformation
    struct EnrollmentInformation: Codable {
        let addConsent, addConsentLovDescr, dropConsent, dropConsentLovDescr: String?
        let enrollmentRequirements: String?
        let requirementDesignation: String?
        let classAttributes: String?

        enum CodingKeys: String, CodingKey {
            case addConsent = "add_consent"
            case addConsentLovDescr = "add_consent_lov_descr"
            case dropConsent = "drop_consent"
            case dropConsentLovDescr = "drop_consent_lov_descr"
            case enrollmentRequirements = "enrollment_requirements"
            case requirementDesignation = "requirement_designation"
            case classAttributes = "class_attributes"
        }
    }

    // MARK: - Encode/decode helpers

    class JSONNull: Codable, Hashable {

        public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
        }

        public var hashValue: Int {
            return 0
        }

        public func hash(into hasher: inout Hasher) {
            // No-op
        }

        public init() {}

        public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }
}
