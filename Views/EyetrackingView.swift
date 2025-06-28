import SwiftUI
import ARKit

struct EyeTrackingView: UIViewRepresentable {
    func makeUIView(context: Context) -> ARSCNView {
        let view = ARSCNView(frame: .zero)
        view.backgroundColor = .clear
        view.scene = SCNScene()  // empty
        view.isUserInteractionEnabled = false
        return view
    }
    func updateUIView(_ uiView: ARSCNView, context: Context) {}
}
