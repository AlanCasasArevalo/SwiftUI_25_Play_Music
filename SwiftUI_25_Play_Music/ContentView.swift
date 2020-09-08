
import SwiftUI
import AVKit

struct ContentView: View {
    
    @State private var audioPlayer: AVAudioPlayer!
    @State private var isPlaying = false
    
    @State private var songs = ["song1", "song2", "song3"]
    @State private var position = 0

    @State private var title = ""
    @State private var album = ""
    @State private var albums = ["album1", "album2", "album3"]

    var body: some View {
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)
            VStack {
                Image(self.album)
                    .font(.system(.largeTitle, design: .rounded))
                    .cornerRadius(20)
                Text(self.title)
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
                self.title = self.getTitle(position: self.position)
                self.album = self.getAlbum(position: self.position)
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
            if self.isPlaying {
                self.audioPlayer.play()
            } else {
                self.audioPlayer.pause()
            }
            title = getTitle(position: position)
            album = getAlbum(position: position)
        }
    }
    
    func backward () {
        if position > 0 {
            self.audioPlayer.stop()
            position -= 1
            getSongToPlay(position: position)
            if self.isPlaying {
                self.audioPlayer.play()
            } else {
                self.audioPlayer.pause()
            }
            title = getTitle(position: position)
            album = getAlbum(position: position)
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
    
    func getTitle(position: Int) -> String {
        return songs[position]
    }

    func getAlbum(position: Int) -> String {
        return albums[position]
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
