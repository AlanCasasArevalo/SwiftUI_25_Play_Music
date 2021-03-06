
import SwiftUI
import AVKit

struct ContentView: View {
    
    @State private var audioPlayer: AVAudioPlayer!
    @State private var isPlaying = false
    
    @State private var isLoopRepeating = false
    
    @State private var songs = ["song1", "song2", "song3"]
    @State private var position = 0
    
    @State private var title = ""
    @State private var album = "album1"
    @State private var albums = ["album1", "album2", "album3"]
    
    @State private var progress: CGFloat = 0
    @State private var value: Double = 0
    
    let width = UIScreen.main.bounds.width - 40

    
    var body: some View {
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)
            VStack {
                
                Toggle(isOn: $isLoopRepeating) {
                    Text("Quieres que se repita hasta el infinito?")
                }
                .padding()
                
                Image(self.album)
                    .font(.system(.largeTitle, design: .rounded))
                    .cornerRadius(20)
                Text(self.title)
                    .font(.system(.largeTitle, design: .rounded))
                    .foregroundColor(.white)
                    .bold()
                
                ZStack (alignment: .leading) {
                    Capsule()
                        .fill(Color.black.opacity(0.5))
                        .frame(width: width, height: 10)
                    Capsule()
                        .fill(Color.white)
                        .frame(width: self.progress, height: 10)
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    let x = value.location.x
                                    self.progress = x
                                })
                                .onEnded({ value in
                                    let x = value.location.x
                                    let screen = self.width
                                    let percentage = x / screen
                                    self.audioPlayer.currentTime = Double(percentage) * self.audioPlayer.duration
                                })
                    )
                    
                }
                
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
            }
            .padding()
            .onAppear {
                
                self.reset()
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    if self.audioPlayer.isPlaying {
                        let screen = UIScreen.main.bounds.width - 30
                        self.value = self.audioPlayer.currentTime / self.audioPlayer.duration
                        self.progress = screen * CGFloat(self.value)
                    } else if self.value >= 0.99 && self.songs.count > self.position {
                        if self.songs.count - 1 == self.position {
                            if self.isLoopRepeating {
                                self.position = 0
                                self.reset()
                                self.isPlaying = true
                                self.audioPlayer.play()
                            } else {
                                self.isPlaying = false
                            }
                        } else {
                            self.forward()
                        }
                    }
                }
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
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay, .allowBluetooth, .allowBluetoothA2DP,.interruptSpokenAudioAndMixWithOthers])
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
    
    func reset () {
        self.title = self.getTitle(position: self.position)
        self.album = self.getAlbum(position: self.position)
        self.getSongToPlay(position: self.position)
        self.value = 0
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
