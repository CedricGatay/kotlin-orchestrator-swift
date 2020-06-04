import Foundation
import SwiftUI

struct InOutView: View {
    @State var nodeManager: NodeManager = NodeManager()

    @State private var inCount = 0
    @State private var outCount = 0
    @State private var pauseDuration: Float = 1

    @State private var startStopMode = false

    var body: some View {

        NavigationView {
            VStack(alignment: .center) {
                HStack(alignment: .center) {
                    Text("#IN: ")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Spacer()
                    Text(String(inCount))
                        .font(.largeTitle)
                }
                .frame(width: 200, alignment: .center)

                HStack(alignment: .center) {
                    Text("#OUT: ")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Spacer()
                    Text(String(outCount))
                        .font(.largeTitle)
                }
                .frame(width: 200, alignment: .center)

                Spacer()

                HStack(alignment: .top) {
                    Button(action: { self.didPressStart() }) {
                        VStack {
                            Image(systemName: "timer")
                                .font(.system(size: 70))
                                .padding(.bottom, 8)
                            Text("Start")
                        }
                        .foregroundColor(self.startStopMode ? .gray : .green)
                    }
                    .padding()
                    .disabled(startStopMode)

                    Button(action: { self.didPressStop() }) {
                        VStack {
                            Image(systemName: "nosign")
                                .font(.system(size: 70))
                                .padding(.bottom, 7)
                            Text("Stop")
                        }
                        .foregroundColor(!self.startStopMode ? .gray : .red)

                    }
                    .padding()
                    .disabled(!startStopMode)
                }
                .frame(width: 200, height: 50, alignment: .center)
                
                Spacer()
                
                HStack(alignment: .center){
                    VStack {
                        Text("Pause (\(pauseDuration, specifier: "%.2f")s)")
                        Slider(value: $pauseDuration,
                               in: 0.1...10,
                               onEditingChanged: self.onPauseChanged
                        ).padding(16)
                    }
                }
                .frame(width: 200, height: 50, alignment: .center)
                
            }
            .frame(height: 400, alignment: .top)
            .frame(height: 500, alignment: .top)
        }
        .navigationBarTitle("In Out", displayMode: .inline)
    }
}

// MARK: - Actions

extension InOutView {
    func didPressStart() {
        print("Start!")
        self.startStopMode = true

        nodeManager.startInOut(closure: {
            DispatchQueue.main.async {
                self.inCount += 1
            }
        }){ cnt in
            DispatchQueue.main.async {
                self.outCount = Int(cnt) ?? -1
            }
        }
    }

    func didPressStop() {
        print("Stop!")
        self.startStopMode = false

        DispatchQueue.main.async {
            self.nodeManager.stopInOut()
        }
    }
    
    func onPauseChanged(_: Bool){
        print(">>> \(self.pauseDuration)")
        DispatchQueue.main.async {
            self.nodeManager.updatePause(self.pauseDuration)
        }
    }
}

// MARK: - Previews

struct InOutView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InOutView()
                .previewDevice("iPhone SE")
        }
    }
}
