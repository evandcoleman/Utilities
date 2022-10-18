//
//  DocumentNavigationBar.swift
//  
//
//  Created by Evan Coleman on 6/11/22.
//

#if canImport(SwiftUI) && canImport(UIKit)
import SFSafeSymbols
import SwiftUI
import UIKit

private let colors: [Color] = [
    Color(hex: "da5d5d"),
    Color(hex: "eb7b59"),
    Color(hex: "e49c4a"),
    Color(hex: "ddbb32"),
    Color(hex: "56b953"),
    Color(hex: "23bfa0"),
    Color(hex: "39bbd0"),
    Color(hex: "33a3e6"),
    Color(hex: "3751ad"),
    Color(hex: "6c43aa"),
    Color(hex: "9f65cd"),
    Color(hex: "d779c0"),
    Color(hex: "76818b"),
    Color(hex: "839083"),
    Color(hex: "8d807e"),
]

private let glyphs: [SFSymbol] = Array(SFSymbol.allSymbols)
    .filter { $0.rawValue.contains(".fill") }
    .sorted { $0.name < $1.name }

public struct DocumentNavigationBar: View {

    @Binding var iconName: String
    @Binding var iconColorHex: String
    @Binding var name: String?

    var placeholder: String?
    var accentColor: Color
    var onOptions: () -> Void
    var onClose: () -> Void

    @State private var isShowingIconDesigner: Bool = false

    public var body: some View {
        HStack(alignment: .center) {
            Button(action: { isShowingIconDesigner = true }) {
                Image(systemName: iconName)
                    .foregroundColor(.white)
            }
            .frame(width: 40, height: 40)
            .background(Color(hex: iconColorHex))
            .gradient()
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(accentColor, lineWidth: 1)
                    .padding(-2)
                    .allowsHitTesting(false)
            )

            TextField(placeholder ?? "", text: .init(get: { name ?? "" }, set: { name = $0 }))
                .font(.system(size: 18, weight: .heavy, design: .default))

            Group {
                Button(action: onOptions) {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.white)
                }
                .frame(width: 28, height: 28)
                .background(accentColor)
                .clipShape(Circle())

                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .foregroundColor(Color(.systemGray2))
                }
                .frame(width: 28, height: 28)
                .clipShape(Circle())
            }
            .padding(.vertical, 8)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .sheet(isPresented: $isShowingIconDesigner) {
            IconDesignerView(
                iconName: $iconName,
                iconColorHex: $iconColorHex,
                dismiss: { isShowingIconDesigner = false }
            )
        }
    }

    public init(iconName: Binding<String>, iconColorHex: Binding<String>, name: Binding<String?>, placeholder: String?, accentColor: Color = .blue, onOptions: @escaping () -> Void, onClose: @escaping () -> Void) {
        self._iconName = iconName
        self._iconColorHex = iconColorHex
        self._name = name
        self.placeholder = placeholder
        self.accentColor = accentColor
        self.onOptions = onOptions
        self.onClose = onClose
    }
}

private struct IconDesignerView: View {

    @Binding var iconName: String
    @Binding var iconColorHex: String

    var dismiss: () -> Void

    @State private var selectedMode: PickerMode = .colors
    @State private var iconSearchText: String = ""

    @FocusState private var isSearching: Bool

    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Spacer()

                Button(action: {}) {
                    Image(systemName: iconName)
                        .font(.system(size: 72))
                        .foregroundColor(.white)
                }
                .frame(width: 150, height: 150)
                .background(Color(hex: iconColorHex))
                .gradient()
                .clipShape(RoundedRectangle(cornerRadius: 44, style: .continuous))

                Spacer()

                Divider()
                Picker("Picker Mode", selection: $selectedMode) {
                    ForEach(PickerMode.allCases, id: \.rawValue) { pickerMode in
                        Text(pickerMode.rawValue.localizedCapitalized)
                            .tag(pickerMode)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 44)
                Divider()

                Group {
                    switch selectedMode {
                    case .colors:
                        LazyHGrid(rows: [.init(.fixed(50)), .init(.fixed(50)), .init(.fixed(50))], spacing: 14) {
                            ForEach(colors, id: \.hashValue) { color in
                                ColorButton(color: color, isSelected: color.hex == iconColorHex) {
                                    iconColorHex = color.hex
                                }
                            }
                        }
                    case .glyphs:
                        VStack {
                            SearchBar("Search", text: $iconSearchText, isFocussed: $isSearching, rightContent: { EmptyView() })
                            ScrollView(.horizontal) {
                                LazyHGrid(rows: [.init(.fixed(50)), .init(.fixed(50)), .init(.fixed(50))], spacing: 14) {
                                    ForEach(getGlyphs(), id: \.rawValue) { symbol in
                                        Button(action: { iconName = symbol.rawValue }) {
                                            Image(systemSymbol: symbol)
                                                .foregroundColor(Color(uiColor: .systemGray))
                                                .ifCondition(symbol.rawValue == iconName) { content in
                                                    content
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                                .fill(Color(uiColor: .systemGray6))
                                                        )
                                                }
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                }
                .frame(height: 220, alignment: .center)
            }
            .navigationTitle("Icon")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: dismiss) {
                        Text("Done")
                            .font(.headline)
                    }
                }
            }
        }
    }

    private func getGlyphs() -> [SFSymbol] {
        if iconSearchText.isEmpty {
            return glyphs
        } else {
            return glyphs
                .filter { $0.rawValue.contains(iconSearchText.replacingOccurrences(of: " ", with: "").lowercased()) }
        }
    }

    enum PickerMode: String, CaseIterable {
        case colors
        case glyphs
    }

    struct ColorButton: View {

        var color: Color
        var isSelected: Bool
        var action: () -> Void

        var body: some View {
            Button(action: action) {
                Circle()
                    .fill(color)
                    .gradient()
                    .frame(width: 44, height: 44)
            }
            .ifCondition(isSelected) { content in
                content
                    .overlay(
                        Circle()
                            .stroke(color, lineWidth: 2)
                            .gradient()
                            .padding(-2)
                    )
            }
        }
    }
}

struct DocumentNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        DocumentNavigationBar(iconName: .constant("tshirt.fill"), iconColorHex: .constant(colors[0].hex), name: .constant(nil), placeholder: "Shortcut Name", onOptions: {}, onClose: {})
            .previewLayout(.sizeThatFits)

        IconDesignerView(iconName: .constant("00.circle.fill"), iconColorHex: .constant(colors[0].hex), dismiss: {})
    }
}

private extension SFSymbol {
    var name: String {
        rawValue.components(separatedBy: ".")[0].localizedCapitalized
    }
}
#endif
