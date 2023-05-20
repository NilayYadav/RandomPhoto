//
//  ContentView.swift
//  RandomPhoto
//
//  Created by Nilay on 20/05/23.

import SwiftUI

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    init(url: URL) {
        loadImage(from: url)
    }
    
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(
            with: url) { data, response, error in
            if let error = error {
                print("Error loading image:", error)
                return
            }
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}

struct ContentView: View {
    @State private var imageURL: URL?
    
    var body: some View {
        ZStack {
            Color(.black).ignoresSafeArea()
            VStack {
                Text("Image Generator")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                
                if let url = imageURL {
                    RemoteImage(url: url)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                Button(action: {
                    // Generate and set a random image URL
                    fetchRandomImage()
                }) {
                    Text("Tap Me")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }
    }
    
    func fetchRandomImage() {
        imageURL = URL(string: "https://picsum.photos/800/800?random=\(Int.random(in: 1...1000))")
    }
}

struct RemoteImage: View {
    @ObservedObject private var imageLoader: ImageLoader
    
    init(url: URL) {
        imageLoader = ImageLoader(url: url)
    }
    
    var body: some View {
        Image(uiImage: imageLoader.image ?? UIImage(systemName: "photo")!)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipped()
            .cornerRadius(50)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
