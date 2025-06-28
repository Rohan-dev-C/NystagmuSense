//
//  MenuViewModel.swift
//  
//
//  Created by Rohan Sampath on 6/28/25.
//

import Foundation
import Combine

@MainActor
final class MenuViewModel: ObservableObject {
    @Published var showHistory = false
    @Published var showCountdown = false
}
