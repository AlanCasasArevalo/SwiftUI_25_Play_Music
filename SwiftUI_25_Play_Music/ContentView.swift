
import SwiftUI
import AVKit

struct ContentView: View {
    
    @State private var audioPlayer: AVAudioPlayer!
    @State private var isPlaying = false
    
    @State private var songs = ["song1", "song2", "song3"]
    @State private var position = 0
    
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
                        self.backward()
                    }) {
                        Image(systemName: "backward.fill")
                            .modifier(CustomButtonModifier())
                    }
                    
                    Button(action: {
                        self.isPlaying.toggle()
                        if self.isPlaying {
                            self.audioPlayer.play()
                        } else {
                            self.audioPlayer.pause()
                        }
                    }) {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .modifier(CustomButtonModifier())
                    }
                    Button(action: {
                        self.forward()
                    }) {
                        Image(systemName: "forward.fill")
                            .modifier(CustomButtonModifier())
                    }
                    
                }
            }.onAppear {
                self.getSongToPlay(position: self.position)
            }
        }
    }
}

extension ContentView {
    func forward () {
        if songs.count - 1 != position {
            self.audioPlayer.stop()
            position += 1
            getSongToPlay(position: position)
            audioPlayer.play()
        }
    }
    
    func backward () {
        if position > 0 {
            self.audioPlayer.stop()
            position -= 1
            getSongToPlay(position: position)
            audioPlayer.play()
        }
    }
    
    func getSongToPlay(position: Int) {
        guard let songPath = Bundle.main.path(forResource: self.songs[position], ofType: "wav") else { return }
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: songPath))
            self.audioPlayer.prepareToPlay()
        } catch let error {
            print(error.localizedDescription)
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
