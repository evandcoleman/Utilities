//
//  SearchBar.swift
//  Utilities
//
//  Created by Evan Coleman on 5/21/21.
//

import SwiftUI

public struct SearchBar<RightContent: View>: View {

    @ScaledMetric var textInset: CGFloat = 25

    public var placeholder: String
    @Binding public var text: String
    public var isFocussed: FocusState<Bool>.Binding
    @ViewBuilder public var rightContent: () -> RightContent

    @State private var isEditing = false

    @Namespace private var animation

    public var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .submitLabel(.done)
                .focused(isFocussed)
                .padding(7)
                .padding(.horizontal, textInset)
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                            .dynamicTypeSize(.xSmall ... .accessibility1)

                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                                    .dynamicTypeSize(.xSmall ... .accessibility1)
                            }
                        }
                    }
                    .accessibilityHidden(true)
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    withAnimation {
                        self.isEditing = true
                    }
                }

            if isEditing {
                Button(action: {
                    withAnimation {
                        self.isEditing = false
                    }
                    self.text = ""
                    self.isFocussed.wrappedValue = false
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
            } else {
                rightContent()
                    .padding(.trailing, 10)
            }
        }
    }

    public init(_ placeholder: String, text: Binding<String>, isFocussed: FocusState<Bool>.Binding, rightContent: @escaping () -> RightContent) {
        self.placeholder = placeholder
        self._text = text
        self.isFocussed = isFocussed
        self.rightContent = rightContent
    }
}

//struct SearchBar_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchBar("Search...", text: .constant(""))
//    }
//}
