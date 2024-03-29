//
//  NavigationImage.swift
//  FourteenPoints
//
//  Created by Evan Coleman on 1/13/21.
//

#if canImport(SwiftUI)
import SwiftUI

public struct NavigationImage: View {

    public var image: Image

    public var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 24, height: 24)
    }

    public init(systemName: String) {
        self.image = Image(systemName: systemName)
    }

    public init(_ image: Image) {
        self.image = image
    }
}

//struct NavigationButton_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationButton()
//    }
//}
#endif
