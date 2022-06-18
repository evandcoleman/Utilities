//
//  LoadingView.swift
//  
//
//  Created by Evan Coleman on 6/8/22.
//

import SwiftUI

public struct LoadingView: View {

    public var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
            Spacer()
        }
    }

    public init() {}
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
