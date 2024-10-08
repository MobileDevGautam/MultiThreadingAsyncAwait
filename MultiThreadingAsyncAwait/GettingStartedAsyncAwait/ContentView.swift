//
//  ContentView.swift
//  GettingStartedAsyncAwait
//
//  Created by Mohammad Azam on 7/9/21.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var currentDateListVM = CurrentDateListViewModel()
    @State private var currentDates:[CurrentDate] = [CurrentDate]()
    
    var body: some View {
        NavigationView {
            List(currentDateListVM.currentDates, id: \.id) { currentDate in
                Text("\(currentDate.date)")
            }.listStyle(.plain)
            
            .navigationTitle("Dates")
            .navigationBarItems(trailing: Button(action: {
                // button action
                Task {
                    await currentDateListVM.populateDates()
                }
            }, label: {
                Image(systemName: "arrow.clockwise.circle")
            }))
        }
        .onAppear(perform: {
            Task {
                await currentDateListVM.populateDates()
            }
        })
        .task {
            await currentDateListVM.populateDates()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
