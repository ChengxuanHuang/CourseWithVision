//
//  RawCourse.swift
//  CurriX
//
//  Created by Welkin Y on 3/12/24.
//

import Foundation

// RawCourse struct from sp2023 Course Builder
//MARK: course json as defined by duke dev console
struct RawCourse: Codable {
    let crse_id: String
    let crse_id_lov_descr, effdt, crse_offer_nbr,
        institution, institution_lov_descr, subject, subject_lov_descr,
        catalog_nbr, course_title_long, ssr_crse_typoff_cd, ssr_crse_typoff_cd_lov_descr,
        msg_text, multi_off, crs_topic_id, course_off_summaries: String?
}
