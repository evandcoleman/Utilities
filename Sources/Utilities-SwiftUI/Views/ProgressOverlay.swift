//
//  ProgressOverlay.swift
//  
//
//  Created by Evan Coleman on 6/27/22.
//

#if canImport(SwiftUI)
import SwiftUI

public struct ProgressOverlay: View {

    public var text: String?

    public var body: some View {
        ZStack {
            Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
            VStack(spacing: 10) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)

                if let text = text {
                    Text(text)
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.black)
                    .opacity(0.6)
            )
            .frame(minWidth: 300, minHeight: 300, alignment: .center)
            .animation(.default, value: text)
        }
    }
}

public extension View {
    func progressOverlay(text: String?) -> some View {
        ifSome(text) { content, text in
            content
                .overlay(ProgressOverlay(text: text))
        }
    }
}
#endif
