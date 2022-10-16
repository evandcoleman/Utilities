//
//  CardView.swift
//  
//
//  Created by Evan Coleman on 7/2/22.
//

import SwiftUI

public struct CardView<Content: View>: View {

    var content: Content

    public var body: some View {
        content
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
    }

    public init(_ content: Content) {
        self.content = content
    }

    public init(_ content: () -> Content) {
        self.content = content()
    }
}

public extension View {
    func card() -> CardView<Self> {
        CardView(self)
    }
}

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView()
//    }
//}
