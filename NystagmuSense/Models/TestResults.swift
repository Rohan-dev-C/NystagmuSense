//
//  TestResults.swift
//  NystagmuSense
//
//  Created by Rohan Sampath on 6/30/25.
//

import CoreData

@objc(TestResult)
public final class TestResult: NSManagedObject {
    @NSManaged public var id:         UUID
    @NSManaged public var date:       Date
    @NSManaged public var score:      Double
    @NSManaged public var shadeLevel: Double
    @NSManaged public var duration:   Double
}

extension TestResult: Identifiable {}
