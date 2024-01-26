//
//  ContentView.swift
//  AsyncAwait
//
//  Created by GAUTAM TIWARI on 26/01/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
    
    func testAsync() {
        
        async {
           //has been deprecated
        }
        
        Task {
            //alternative
        }
        
        
        
        asyncDetached {
            //has been deprecated
        }
        
        Task.detached {
            //alternative
        }
        
    }
}

#Preview {
    ContentView()
}
