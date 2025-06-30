//
//  TestView.swift
//  NystagmuSense
//
//  Created by Rohan Sampath on 6/30/25.
//

import SwiftUI

struct TestView: View {
    @StateObject private var vm = TestViewModel()
    var body: some View {
        ZStack {
            FadingStripeView(shade: $vm.shadeLevel)
            EyeTrackingView()
        }
        .onAppear { vm.start() }
        .overlay(alignment: .topTrailing) {
            if let s = vm.score { ScoreCard(score: s).padding() }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}
