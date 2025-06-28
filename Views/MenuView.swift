
//
//  MenuView.swift
//  
//
//  Created by Rohan Sampath on 6/28/25.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject private var vm: MenuViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()
                Text("NystagmuSense")
                    .font(.largeTitle.bold())
                Spacer()
                Button("Past Tests")  { vm.showHistory  = true }
                    .buttonStyle(.borderedProminent)
                Button("Start Test")  { vm.showCountdown = true }
                    .buttonStyle(.bordered)
                Spacer()
            }
            .navigationDestination(isPresented: $vm.showHistory)  { HistoryView() }
            .navigationDestination(isPresented: $vm.showCountdown) { CountdownOverlay() }
        }
    }
}
