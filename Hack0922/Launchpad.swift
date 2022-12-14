//
//  Oracle.swift
//  Hack0922
//
//  Created by Tema Sysoev on 24.09.2022.
//

import SwiftUI
struct Pair: Hashable{
    var id = 0
    var assetFrom = Asset()
    var assetTo = Asset()
    
    
    var ratio = 0.0
   
}
struct Asset:Hashable{
    var id = 0
    var name = ""
    var ticker = ""
    var volume_24h = 0
}
struct Launchpad: View {
    public var token = "ZYpllhQnt7I8xirgkIXU5wy4cMr7GmeeRFiSkN7MvVURSxGsE1bWu778ZLIgOud1"
    @State private var pairs = [Pair]()
    @Environment(\.openURL) var openURL
    private func loadData(){
        pairs = [Pair]()
        Task{
            do{
                guard let url = URL(string: "http://45.67.56.33:8228/api/v1/trading/pairs/all/")
                else
                {
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.addValue(token, forHTTPHeaderField: "x-api-key")
                let (data, _) = try await URLSession.shared.data(from: url)
                print(data)
               
                let jsonFeed = try JSONDecoder().decode([LaunchpadJSON].self, from: data)
                print(jsonFeed)
                for pair in jsonFeed{
                    pairs.append(Pair(id: pair.id, assetFrom: Asset(id: pair.id, name: pair.asset_a.name, ticker: pair.asset_a.ticker, volume_24h: pair.asset_a.volume_24h), assetTo: Asset(id: pair.id, name: pair.asset_b.name, ticker: pair.asset_b.ticker, volume_24h: pair.asset_b.volume_24h), ratio: Double(pair.weight_a)!/Double(pair.weight_b)!))
                }
            }
         catch {
            print(error)
        }
           
        }
    }
    var body: some View {
        NavigationView{
            List{
                ForEach(pairs, id: \.self) { pair in
                    
                    HStack(alignment: .center){
                        Menu{
                           
                                Text(pair.assetFrom.name)
                                
                            Text("Volume (24 h): \(pair.assetFrom.volume_24h)")
                            
                            
                        } label: {
                            Text("\(pair.assetFrom.ticker)")
                        }
                        Text("=")
                       
                        Spacer()
                        
                       
                       
                       
                            
                            Text(String(format: "%.2f", pair.ratio))
                                .bold()
                          
                        Menu{
                           
                                Text(pair.assetTo.name)
                                
                            Text("Volume (24 h): \(pair.assetTo.volume_24h)")
                            
                            
                        } label: {
                            Text("\(pair.assetTo.ticker)")
                                .frame(width: 50, alignment: .trailing)
                                
                        }
                        
                        Button(action: {
                            openURL(URL(string: "http://18.207.243.215:3000/")!)
                        }, label: {
                            Image(systemName: "arrow.left.arrow.right")
                        })
                        .padding(.all, 5)
                      
                        .buttonStyle(.borderedProminent)
                        
                    }
                }
            }
            .refreshable {
                loadData()
            }
            .onAppear{
                loadData()
            }
            .navigationTitle(Text("Launchpad"))
        }
    }
}

struct Launchpad_Previews: PreviewProvider {
    static var previews: some View {
        Launchpad()
    }
}
