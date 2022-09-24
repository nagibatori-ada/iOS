//
//  ContentView.swift
//  Hack0922
//
//  Created by Tema Sysoev on 23.09.2022.
//

import SwiftUI
import Charts

struct Currency: Hashable{
 
    var ticker = ""
    
    var name = ""
    
    var volume = 0
    var volume_24h = 0
    
    var stakeholders = 0
    
    var currentPrice = 0.0
    var history = [0.0]
}
 
struct DateAndData: Hashable, Identifiable{
    var id = 0
    var date = 0
    var data = 0.0
}
struct OraculView: View {
    public var token = "ZYpllhQnt7I8xirgkIXU5wy4cMr7GmeeRFiSkN7MvVURSxGsE1bWu778ZLIgOud1"
    @State private var pairs = [Currency]()
    
    
    @State private var userID = ""
    
    func createHistory(data: [Double]) -> [DateAndData]{
        var result = [DateAndData]()
        for index in 0..<data.count{
            result.append(DateAndData(date: -index, data: data[index]))
        }
        return result
    }
    
    @State private var tappedCurrency = ""
    
    
    private func loadData(){
        pairs = [Currency]()
        Task{
            do{
                guard let url = URL(string: "http://45.67.56.33:8228/api/v1/cmc/")
                else
                {
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.addValue(token, forHTTPHeaderField: "x-api-key")
                let (data, _) = try await URLSession.shared.data(from: url)
                print(data)
               
                let jsonFeed = try JSONDecoder().decode([OraculJSON].self, from: data)
                print(jsonFeed)
                for pair in jsonFeed{
                    pairs.append(Currency(ticker: pair.ticker, name: pair.name, volume: Int(pair.volume)!, volume_24h: Int(pair.volume_24h)!, currentPrice: Double(pair.price)!, history: makeList(20, maxLimit: Double(pair.price)!*1.1)))
                }
            }
         catch {
            print(error)
        }
           
        }
    }
    func makeList(_ n: Int, maxLimit: Double) -> [Double] {
        return (0..<n).map { _ in .random(in: 1...maxLimit) }
    }
    var body: some View {
        NavigationView{
            List {
                ForEach(pairs, id: \.self) { pair in
                    NavigationLink(destination: {
                        DetailView(currency: pair)
                    }, label: {
                        
                        VStack(alignment: .leading){
                            
                            
                            HStack{
                                Text(pair.ticker)
                                    .font(.title2)
                                    .foregroundColor(Color("AccentColor 1"))
                                    .bold()
                                Text(pair.name)
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                               
                                Text(String(format: "%.2f", pair.currentPrice))
                                    .font(.title2)
                                    .bold()
                                
                                
                            }
                           
                            HStack{
                                Chart(createHistory(data: pair.history), id: \.self){item in
                                    LineMark(
                                        x: .value("Date", item.date),
                                        y: .value("Data", item.data)
                                    )
                                    .foregroundStyle(pair.history.first! < pair.history.last! ? Color.green : Color.red)
                                    
                                    
                                }
                                .frame(height: 50)
                                
                                .chartXAxis {
                                    AxisMarks(values: .automatic) { _ in
                                        
                                    }
                                }
                                .chartYAxis {
                                    AxisMarks(values: .automatic) { _ in
                                        
                                    }
                                }
                                
                                
                                
                            }
                            
                            
                        }
                    })
                }
            }
            .refreshable {
                loadData()
            }
            .onAppear{
                if pairs.count < 3{
                    loadData()
                }
            }
            .navigationTitle(Text("Oracul"))
            
        }
        
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        OraculView()
    }
}
