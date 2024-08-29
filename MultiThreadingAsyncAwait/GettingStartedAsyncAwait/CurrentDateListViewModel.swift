//
//  CurrentDateListViewModel.swift
//  GettingStartedAsyncAwait
//
//  Created by GAUTAM TIWARI on 29/08/24.
//

import Foundation

@MainActor
class CurrentDateListViewModel: ObservableObject {
    
    @Published var currentDates: [CurrentDateViewModel] = []
    
    func populateDates() async {
        do {
            let currentDate = try await WebService().getDate()
            if let currentDate = currentDate {
                self.currentDates.append(CurrentDateViewModel(currentDate: currentDate))
            }
        }
        catch {
            print(error)
        }
    }
}

struct CurrentDateViewModel {
    let currentDate: CurrentDate
    
    var id: UUID {
        currentDate.id
    }
    
    var date: String {
        currentDate.date
    }
}
