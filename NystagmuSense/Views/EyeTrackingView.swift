//
//  EyeTrackingView.swift
//  NystagmuSense
//
//  Created by Rohan Sampath on 6/30/25.
//

import SwiftUI
import ARKit

struct EyeTrackingView: UIViewRepresentable {
    func makeUIView(context: Context) -> ARSCNView {
        let v = ARSCNView()
        v.backgroundColor = .clear
        v.scene = SCNScene()
        return v
    }
    func updateUIView(_ uiView: ARSCNView, context: Context) {}
}
