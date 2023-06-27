//
//  ContentView.swift
//  WorldWondersSwiftUI
//
//  Created by Imac on 26.04.2023.
//

import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI

struct WorldWonder: Identifiable {
    var id = UUID()
    var name = ""
    var region = ""
    var location = ""
    var flag = ""
    var picture = ""

    
    init(json: JSON) {
        if let item = json["name"].string {
            name = item
        }
        if let item = json["location"].string {
            location = item
        }
        if let item = json["flag"].string {
            flag = item
        }
        if let item = json["picture"].string {
            picture = item
        }

        
    }
    
}

struct WonderRow: View {
    
    var wonderItem: WorldWonder
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: wonderItem.picture))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100.0, height: 100.0)
                .clipped()
                .cornerRadius(6)
            VStack(alignment: .leading, spacing: 4) {
                Text(wonderItem.name)
                Text(wonderItem.region)
                
                HStack {
                    WebImage(url: URL(string: wonderItem.flag))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 20.0)

                    Text (wonderItem.location)
                }
            }
        }

        
        }
}


struct ContentView: View {
    
    @ObservedObject var wonderList = GerWonders()
    
    var body: some View {
        NavigationView {
            List (wonderList.wonderArray) { wonderItem in
                WonderRow(wonderItem: wonderItem)
            }
            .refreshable {
                self.wonderList.updateData()
            }
            .navigationTitle("World Wonders")
            .navigationTitle("World Wonders")
        }
        
        }
        
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class GerWonders: ObservableObject {
    @Published var wonderArray = [WorldWonder]()
    
    init(){
        updateData()
    }
    
    func updateData() {
        let urlString =
            "https://demo3886709.mockable.io/getWonders"
        
        let url = URL(string: urlString)
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url!) { (data, _, error) in
            
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            
            let json = try! JSON(data: data!)
            if let resultArray = json.array {
                self.wonderArray.removeAll()
                for item in resultArray {
                    let wonderItem = WorldWonder(json: item)
                    
                    DispatchQueue.main.async {
                        self.wonderArray.append(wonderItem)
                    }
                }
            }
        }.resume()
    }
    
}
