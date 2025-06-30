//
//  MenuViewModel.swift
//  NystagmuSense
//
//  Created by Rohan Sampath on 6/30/25.
//

import Foundation
@MainActor
final class MenuViewModel: ObservableObject {
    @Published var showHistory   = false
    @Published var showCountdown = false
}
 
