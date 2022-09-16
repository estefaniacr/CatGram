//
//  CarouselView.swift
//  CatGram
//
//  Created by Estefania Cano Robles on 09/09/22.
//

import SwiftUI

struct CarouselView: View {
    
    @State var selection: Int = 1
    let maxCount: Int = 8
    @State var timerAdded: Bool = false
    
    var body: some View {
        TabView(selection: $selection, content: {
            
            ForEach(1..<8, content: { count in
                Image("cat\(count)")
                    .resizable()
                    .scaledToFill()
                    .tag(count)
            })
        })
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 300)
        .animation(.default)
        .onAppear {
            if !timerAdded {
                addTimer()
            }
        }
    }
    
    // MARK: FUNCTIONS
    
    func addTimer() {
        
        timerAdded = true
        let timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
            
            if selection == (maxCount - 1) {
                selection = 1
            } else {
                selection += 1
            }
        }
        
        timer.fire()
    }
}

struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView()
            .previewLayout(.sizeThatFits)
    }
}
