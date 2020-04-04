//
//  ContentView.swift
//  NetworkingDemoApp
//
//  Created by Isc. Torres on 4/4/20.
//  Copyright © 2020 isctorres. All rights reserved.
//

import SwiftUI

struct Response : Codable {
    var results : [Result]
}

struct Result : Codable {
    var trackId : Int
    var trackName : String
    var collectionName : String
}

struct ContentView: View {
    
    @State private var results = [Result]()
    
    var body: some View {
        NavigationView{
            List{
                ForEach(results, id: \.trackId){ item in
                    VStack(alignment: .leading){
                        Text(item.trackName).font(.headline)
                        Text(item.collectionName)
                    }
                }
            }
            .onAppear(perform: loadData)
            .navigationBarTitle("Songs List")
            
        }
    }
    
    func loadData(){
        
        // Paso 1
        guard let url = URL(string: "https://itunes.apple.com/search?term=Banda&entity=song") else {
            print("Invalid URL")
            return
        }
        
        // Paso 2
        let request = URLRequest(url: url)
    
        // Paso 3
        URLSession.shared.dataTask(with: request){ data, response, error in
            // Paso 4
            if let data2 = data {
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data2){
                    DispatchQueue.main.async {
                        // Execute in main thread
                        self.results = decodedResponse.results
                    }
                    return
                }
            }
            // Error
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
