import SwiftUI

struct ContentView: View {
    @State var nodeManager: NodeManager = NodeManager()

    var body: some View {
        TabView {
            InOutView()
                .tabItem {
                    VStack {
                        Image(systemName: "bolt.circle")
                        Text("InOut")
                    }
            }.tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(nodeManager: NodeManager())
    }
}
