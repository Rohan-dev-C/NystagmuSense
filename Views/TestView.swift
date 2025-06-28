//
//  TestView.swift
//  
//
//  Created by Rohan Sampath on 6/28/25.
//
import SwiftUI

struct TestView: View {
    @StateObject private var vm = TestViewModel()

    var body: some View {
        ZStack {
            FadingStripeView(shade: $vm.shadeLevel)
            EyeTrackingView()
        }
        .onAppear { vm.startTest() }
        .overlay(alignment: .topTrailing) {
            if let score = vm.score {
                ScoreCard(score: score)
                    .padding()
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}
