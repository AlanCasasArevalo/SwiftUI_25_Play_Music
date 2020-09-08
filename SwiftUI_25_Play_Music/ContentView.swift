
import SwiftUI
import AVKit

struct ContentView: View {
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
                        
                    }) {
                        Image(systemName: "play.fill")
                            .modifier(CustomButtonModifier())
                    }
                    
                    Button(action: {
                        
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
