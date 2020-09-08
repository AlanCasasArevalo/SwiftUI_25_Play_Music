
import SwiftUI
import AVKit

struct ContentView: View {
    
    @State private var audioPlayer: AVAudioPlayer!
    
    var body: some View {
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)
            VStack {
                Text("Hello, World!")
                    .font(.system(.largeTitle, design: .rounded))
                    .foregroundColor(.white)
                    .bold()
                HStack {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "backward.fill")
                            .modifier(CustomButtonModifier())
                    }
                    
                    Button(action: {
                        self.audioPlayer.play()
                    }) {
                        Image(systemName: "play.fill")
                            .modifier(CustomButtonModifier())
                    }
                    
                    Button(action: {
                        self.audioPlayer.pause()
                    }) {
                        Image(systemName: "pause.fill")
                            .modifier(CustomButtonModifier())
                    }
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "forward.fill")
                            .modifier(CustomButtonModifier())
                    }
                    
                }
            }.onAppear {
                guard let songPath = Bundle.main.path(forResource: "song1", ofType: "wav") else { return }
                do {
                    self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: songPath))
                    self.audioPlayer.prepareToPlay()
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CustomButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color(.white))
            .font(.system(.largeTitle, design: .rounded))
            .padding()
    }
}
