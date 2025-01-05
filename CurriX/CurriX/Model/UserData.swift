//
//  UserData.swift
//  CurriX
//
//  Created by 黄承暄 on 4/4/24.
//

import Foundation

class ClassComponentPair: Codable {
    let dukeClass: DukeClass
    let classComponent: ClassComponent
    init(dukeClass: DukeClass, classComponent: ClassComponent) {
        self.dukeClass = dukeClass
        self.classComponent = classComponent
    }
}

struct CalendarBlock: Identifiable {
    var id: Int

    let course: Course?
    let pair: ClassComponentPair?
    let interval: TimeInterval
    init(course: Course?, pair: ClassComponentPair?, interval: TimeInterval, id: Int) {
        self.course = course
        self.pair = pair
        self.interval = interval
        self.id = id
    }
}

class UserChosenCalendar: ObservableObject {
    static var shared = UserChosenCalendar()
    private init() {
        try? load()
    }

    // Property
    @Published var dictClass: [String:[Course:ClassComponentPair]] = [:]

    // File URL
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    private let SaveURL = DocumentsDirectory.appendingPathComponent("UserChosenCalendar")

    func add(_ term: String, course: Course, dukeClass: DukeClass, classComponent: ClassComponent) -> Bool {
        var dictTmp = dictClass

        if let _ = dictClass[term] {
            dictTmp[term]?[course] = ClassComponentPair(dukeClass: dukeClass, classComponent: classComponent)
        } else {
            dictTmp[term] = [:]
            dictTmp[term]?[course] = ClassComponentPair(dukeClass: dukeClass, classComponent: classComponent)
        }

        var duplication = false

        for day in Days.allCases {
            let prev = getDayView(dict: dictTmp, term: term, day: day)
            let now = deDuplicate(prev)
            if prev.count != now.count {
                print("duplication detected in \(day.rawValue)")
                duplication = true
            }
        }

        if !duplication {
            for _term in dictTmp.keys {
                if _term != term {
                    dictTmp[_term]?.removeValue(forKey: course)
                }
            }
            dictClass = dictTmp
            try? save()
            return true
        }
        return false
    }
    
    func remove(_ course: Course) {
        for _term in dictClass.keys {
            dictClass[_term]?.removeValue(forKey: course)
        }
        try? save()
    }

    func save() throws {
        var outputData = Data()
        let encoder = JSONEncoder()
        let encoded = try encoder.encode(self.dictClass)
        outputData = encoded
        try outputData.write(to: SaveURL)
    }

    func load() throws {
        let decoder = JSONDecoder()
        var tempData: Data? = nil

        do {
            tempData = try Data(contentsOf: SaveURL)
            if tempData != nil {
                dictClass = try decoder.decode([String:[Course:ClassComponentPair]].self, from: tempData!)
            }
        } catch _ as NSError {
            // The file cannot be found
        }
    }

    func getDayView(dict: [String:[Course:ClassComponentPair]], term: String, day: Days) -> [(Course, ClassComponentPair)] {
        var ret = dict[term]?.filter({
            $0.value.classComponent.meetingPattern?.days.contains(day) == true && $0.value.classComponent.meetingPattern?.startTime != nil && $0.value.classComponent.meetingPattern?.endTime != nil
        }).map({key, value in (key, value)}).sorted(by: {
            a, b in
            if let aT = a.1.classComponent.meetingPattern?.startTime, let bT = b.1.classComponent.meetingPattern?.startTime {
                return aT < bT
            }
            return true
        })
        return ret ?? []
    }

    func deDuplicate(_ list: [(Course, ClassComponentPair)]) -> [(Course, ClassComponentPair)] {
        var prevEndTime: Date? = nil

        var ret: [(Course, ClassComponentPair)] = []

        for (course, pair) in list {
            if prevEndTime != nil {
                if prevEndTime! <= pair.classComponent.meetingPattern!.startTime! {
                    ret.append((course, pair))
                    prevEndTime = pair.classComponent.meetingPattern!.endTime!
                }
            } else {
                ret.append((course, pair))
                prevEndTime = pair.classComponent.meetingPattern!.endTime!
            }
        }
        return ret;
    }

    func generateBlocks(term: String, day: Days) -> [CalendarBlock] {
        let list = deDuplicate(getDayView(dict: dictClass, term: term, day: day))

        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(abbreviation: "UTC")

        var startDate = formatter.date(from: "08:00")!
        var ret: [CalendarBlock] = []
        for (course, pair) in list {
            let newStart = pair.classComponent.meetingPattern!.startTime!
            let newEnd = pair.classComponent.meetingPattern!.endTime!
            if newStart > startDate {
                ret.append(CalendarBlock(course: nil, pair: nil, interval: newStart.timeIntervalSince(startDate), id: ret.count))
                ret.append(CalendarBlock(course: course, pair: pair, interval: newEnd.timeIntervalSince(newStart), id: ret.count))
            } else if newStart == startDate {
                ret.append(CalendarBlock(course: course, pair: pair, interval: newEnd.timeIntervalSince(newStart), id: ret.count))
            }
            startDate = newEnd
        }

        print(day, ret)

        return ret
    }
}

class UserChosenShoppingCart: ObservableObject {
    // Make the class a singleton
    static var shared = UserChosenShoppingCart()
    private init() {
        try? load()
    }
    
    func isAdded(_ course: Course) -> Bool {
        return courseList.contains(course)
    }

    // Property
    @Published var courseList: Set<Course> = []
    var sortedCourseList: [Course] {
        courseList.sorted { lhs, rhs in
            if lhs.subject.code.contains("MENG") && rhs.subject.code.contains("ECE") {
                return true
            } else if lhs.subject.code.contains("ECE") && rhs.subject.code.contains("MENG") {
                return false
            }
            if lhs.subject.code < rhs.subject.code {
                return true
            } else {
                return lhs.catalogNumber < rhs.catalogNumber
            }
        }
    }

    // File URL
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    private let SaveURL = DocumentsDirectory.appendingPathComponent("UserChosenShoppingCart")

    func save() throws {
        var outputData = Data()
        let encoder = JSONEncoder()
        let encoded = try encoder.encode(self.courseList)
        outputData = encoded
        try outputData.write(to: SaveURL)
    }

    func load() throws {
        let decoder = JSONDecoder()
        var tempData: Data? = nil

        do {
            tempData = try Data(contentsOf: SaveURL)
            if tempData != nil {
                courseList = try decoder.decode(Set<Course>.self, from: tempData!)
            }
        } catch _ as NSError {
            // The file cannot be found
        }
    }

    func add(_ course: Course) {
        courseList.insert(course)
        try? save()
    }
    
    func remove(_ course: Course) {
        courseList.remove(course)
        try? save()
    }
}
