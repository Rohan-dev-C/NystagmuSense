//
//  CountdownOverlay.swift
//  
//
//  Created by Rohan Sampath on 6/28/25.
//
import SwiftUI

struct CountdownOverlay: View {
    @StateObject private var vm = CountdownViewModel()
    @State private var pushTest = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text("\(vm.secondsRemaining)")
                .font(.system(size: 100, weight: .bold))
                .foregroundColor(.white)
        }
        .onAppear { vm.start() }
        .onChange(of: vm.secondsRemaining) { value in
            if value <= 0 { pushTest = true }
        }
        .navigationDestination(isPresented: $pushTest) { TestView() }
    }
}
