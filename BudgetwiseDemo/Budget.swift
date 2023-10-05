//
//  Budget.swift
//  BudgetwiseDemo
//
//  Created by Ben Ashkenazi on 10/3/23.
//

import Foundation
import SwiftUI


struct Budget: Identifiable, Codable {
    let id = UUID()
    let name: String
    let imageName: String
    //let barColor: Color
    var amountSpent: Double
    var amountBudgeted: Double
}
