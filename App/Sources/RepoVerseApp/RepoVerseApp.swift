import SwiftUI
import RepoVerseShared

@main
struct RepoVerseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Text("RepoVerse 3D Visualizer")
                .font(.largeTitle)
            Text("Launch via Xcode Extension or Open a Folder")
        }
        .padding()
        .frame(minWidth: 800, minHeight: 600)
    }
}
