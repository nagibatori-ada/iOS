//
//  DetailView.swift
//  Hack0922
//
//  Created by Tema Sysoev on 24.09.2022.
//

import SwiftUI
import Charts
struct DetailView: View {
    public var currency: Currency
    func createHistory(data: [Double]) -> [DateAndData]{
        var result = [DateAndData]()
        for index in 0..<data.count{
            result.append(DateAndData(date: -index, data: data[index]))
        }
        return result
    }
    var body: some View {
        
        VStack(alignment: .leading){
            
            VStack(alignment: .leading){
                Text("Stakeholders: \(currency.stakeholders)")
                    
                Text("Volume (lifetime): \(currency.volume)")
                Text("Volume (24 hrs): \(currency.volume_24h)")
            }
            
            .font(.footnote)
                .padding(.horizontal)
            Divider()
            HStack{
                Text("Time")
                    .bold()
                    .foregroundColor(.accentColor)
                Spacer()
                
                Text("Price")
                    .bold()
                    .foregroundColor(.accentColor)
            }
            .padding(.horizontal)
            List{
                ForEach(createHistory(data: currency.history), id: \.self) { row in
                    HStack{
                        Text("\(Calendar.current.component(.hour, from: Calendar.current.date(byAdding: .hour, value: row.date, to: Date())!)):00")
                        Spacer()
                        Text("\(row.data)")
                    }
                }
            }
            .listStyle(.inset)
            Chart(createHistory(data: currency.history), id: \.self){item in
                LineMark(
                    x: .value("Date", item.date),
                    y: .value("Data", item.data)
                )
                .foregroundStyle(currency.history.first! < currency.history.last! ? Color.green : Color.red)
                
                
            }
          
            
            .chartXAxis {
                AxisMarks(values: .automatic) { _ in
                    AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 2]))
                      .foregroundStyle(Color.gray)
                    AxisTick(stroke: StrokeStyle(lineWidth: 1))
                      .foregroundStyle(Color.gray)
                    AxisValueLabel()
                  }
            }
            .chartYAxis {
                AxisMarks(values: .automatic) { _ in
                    AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 2]))
                      .foregroundStyle(Color.gray)
                    AxisTick(stroke: StrokeStyle(lineWidth: 1))
                      .foregroundStyle(Color.gray)
                    AxisValueLabel()
                  }
            }
        }
        .navigationTitle(Text(currency.name))
    }
}

