//
//  CourseInfoView.swift
//  CurriX
//
//  Created by Welkin Y on 4/3/24.
//

import SwiftUI
import MapKit

// visualize class infomation
// MapView: class location
// Text descriptions
// Prerequisites
import FlyoverKit

struct ClassInfoView: View {
    @State var dukeClass: DukeClass? = nil
    var course: Course
    var term: Term
    @State var loading = true
    
    init(course: Course, term: Term) {
        self.course = course
        self.term = term
    }
    
    @State private var location: CLLocationCoordinate2D? = nil

    func locateAddress(name: String) async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = name
        let searchItems = try? await MKLocalSearch(request: request).start()
        let results = searchItems?.mapItems ?? []
        location = results[0].placemark.coordinate
    }

    var body: some View {
        HStack {
            if loading {
                Spacer()
                ProgressView(label: {
                    Text("Loading")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                ).progressViewStyle(.circular)
                Spacer()
            } else {
                
                
                if let location {
                    FlyoverMap(
                        latitude: location.latitude,
                        longitude: location.longitude,
                        configuration: .init(
                            altitude: .init(250),
                            pitch: .init(70),
                            heading: .increment(by: 10)
                        ),
                        mapType: .satellite
                    )
                    .ignoresSafeArea()
                }
                
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        // Class Details For debugging
                        if let descriptionLong = dukeClass?.descriptionLong {
                            Text("\(descriptionLong)")
                                .font(.title)
                        }
                        
                        // Optional Information
                        if let career = dukeClass?.career {
                            Text("Career: \(career)")
                        }
                        if let campus = dukeClass?.campus {
                            Text("Campus: \(campus)")
                        }
                        if let consent = dukeClass?.consent {
                            Text("Consent: \(consent)")
                        }
                        
                        // Components List
                        if !(dukeClass?.components.isEmpty ?? true) {
                            ForEach(dukeClass!.components, id: \.description) { component in
                                if let meetTime = component.meetingPattern?.description {
                                    Text("Time: \(meetTime)")
                                }
                                if let location = component.meetingPattern?.facilityLongDescript {
                                    Text("Location: \(location)")
                                }
                                if let instructors = component.meetingPattern?.instructors {
                                    Text("Instructors: \(instructors.joined(separator: ", "))")
                                }
                            }
                        }
                        
                        // Enrollment Information
                        if let enrollCount = dukeClass?.enrollmentCount,
                           let enrollCap = dukeClass?.enrollmentCap {
                            Text("Enrollment Status:")
                            CustomProgressView(count: enrollCount, cap: enrollCap)
                        }
                        if let waitListCount = dukeClass?.waitListCount,
                           let waitListCap = dukeClass?.waitListCap {
                            Text("Waitlist Status:")
                            CustomProgressView(count: waitListCount, cap: waitListCap)
                        }
                    }
                    .padding()
                }
            }
        }
        .task {
            Task {
                do {
                    dukeClass = try await downloadCourseDetail(strm: term, crse: course)[0]
                    dukeClass = try await downloadClassDetail(dukeClass: dukeClass!)
                    if let dukeClass = dukeClass {
                        if !dukeClass.components.isEmpty {
                            let component = dukeClass.components[0]
                            if let latitude = Double(component.meetingPattern?.latitude ?? "nil"),
                               let longitude = Double(component.meetingPattern?.longitude ?? "nil") {
                                location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                            } else if let facilityName = component.meetingPattern?.facilityLongDescript {
                                await locateAddress(name: "\(dukeClass.campus ?? "Duke University") \(facilityName)")
                            } else {
                                await locateAddress(name: "\(dukeClass.campus ?? "Duke University")")
                            }
                        }
                    } else {
                        await locateAddress(name: "Duke University")
                    }
                } catch {
                    dukeClass = nil
                    print(error.localizedDescription)
                }
                loading = false
            }
        }
        .onAppear {
            Task {
                
            }
        }
    }
}

struct CustomProgressView: View {
    var count: Int
    var cap: Int
     
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(.gray)
                    .frame(height: 20.0)
                    .frame(width: geometry.size.width)
                    .overlay(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10.0)
                            .fill(.green.opacity(0.7))
                            .frame(width: geometry.size.width * CGFloat(count) / CGFloat(cap))
                            .overlay {
                                Text("\(count)")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                    }
                    .overlay(alignment: .trailing) {
                        RoundedRectangle(cornerRadius: 10.0)
                            .fill(.gray)
                            .frame(width: geometry.size.width * CGFloat(cap-count) / CGFloat(cap))
                            .overlay {
                                Text("\(cap-count)")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                    }
            }
        }
    }
}
