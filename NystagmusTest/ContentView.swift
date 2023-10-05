import SwiftUI
import Combine
import EyeTracking

var backgroundAnimationFinished = false

struct MovingLines: View {
    let lineWidth: CGFloat = 5
    let lineHeight: CGFloat = 20
    let lineSpacing: CGFloat = 50 // Adjust the spacing between lines
    let lineSpeed: Double
    let backgroundAnimationDuration: Double = 2.0

    @State private var yOffset: CGFloat = 0
    @State private var isWhiteBackground = true
   

    init(lineSpeed: Double) {
        self.lineSpeed = lineSpeed
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundColor
                    .edgesIgnoringSafeArea(.all)

                ForEach(0..<numberOfLines(geometry: geometry)) { index in
                    LineView(yOffset: self.yOffset + CGFloat(index) * (self.lineHeight + self.lineSpacing))
                        .foregroundColor(.black)
                }
            }
            .onAppear {
                startMoving()
                startBackgroundAnimation()
            }
        }
    }

    private func numberOfLines(geometry: GeometryProxy) -> Int {
        Int(ceil(geometry.size.height / (lineHeight + lineSpacing)) + 1)
    }

    private func startMoving() {
        Timer.scheduledTimer(withTimeInterval: lineSpeed, repeats: true) { _ in
            withAnimation(.linear(duration: lineSpeed)) {
                yOffset -= 1

                if yOffset <= -(lineHeight + lineSpacing) {
                    yOffset = 0
                }
            }
        }
    }

    private func startBackgroundAnimation() {
        withAnimation(Animation.easeInOut(duration: backgroundAnimationDuration).repeatForever(autoreverses: true)) {
            isWhiteBackground.toggle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + backgroundAnimationDuration) {
            backgroundAnimationFinished = true
        }
    }

    private var backgroundColor: Color {
        isWhiteBackground ? .white : .black
    }
}

struct LineView: View {
    let yOffset: CGFloat

    var body: some View {
        Path { path in
            let startPoint = CGPoint(x: 0, y: yOffset)
            let endPoint = CGPoint(x: UIScreen.main.bounds.width, y: yOffset)
            path.move(to: startPoint)
            path.addLine(to: endPoint)
        }
        .stroke(lineWidth: 5)
    }
}


struct ContentView: View {
    @State private var isTesting = false
    @State private var isFinished = false
    @State private var elapsedTime: TimeInterval = 0
    @State private var backgroundColor = Color.blue

    let eyeTracking = EyeTracking(configuration: Configuration(appID: "NystagmusTestApp", blendShapes: [.eyeBlinkLeft, .eyeBlinkRight]))
    
    var body: some View {
        ZStack {
            backgroundColor
                .edgesIgnoringSafeArea(.all)

            VStack {
                if isTesting {
                    if isFinished {
                        Text("1.93")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.blue)
                            .cornerRadius(10)
                    } else {
                        MovingLines(lineSpeed: 0.002)
                    }
                } else {
                    Text("Contrast Sensitivity Function Exam")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)

                    Button(action: startTest) {
                        Text("Start Test")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.blue)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .onReceive(timer) { time in
            if isTesting && !isFinished {
                elapsedTime += 1
                if elapsedTime >= 20 {
                    let dataSession = try? EyeTracking.export(sessionID: "8136AD7E-7262-4F07-A554-2605506B985D")
                    isFinished = true
                    backgroundColor = Color.white
                }
            }
        }
    }

    private func startTest() {
        isTesting = true
        elapsedTime = 0
        backgroundColor = Color.blue
        isFinished = false
    }

    private var timer: AnyPublisher<Date, Never> {
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .eraseToAnyPublisher()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

