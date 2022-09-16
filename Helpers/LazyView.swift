//
//  LazyView.swift
//  CatGram
//
//  Created by Estefania Cano Robles on 12/09/22.
//

import Foundation
import SwiftUI

struct LazyView<Content: View>: View {
    
    var content: () -> Content
    
    var body: some View {
        self.content()
    }
}
