//
//  ErrorHandling.swift
//  Utilities
//
//  Created by Evan Coleman on 1/24/22.
//

import SwiftUI

public struct ErrorAlert: Identifiable {
    public var id = UUID()
    public var message: String
    public var dismissAction: (() -> Void)?
    public var error: Error
}

public class ErrorHandling: ObservableObject {
    @Published public var currentAlert: ErrorAlert?

    public init() {
        currentAlert = nil
    }

    public func handle(error: Error, file: String = #file, line: Int = #line) {
        log.error(file: file, line: line, error)
        currentAlert = ErrorAlert(message: error.localizedDescription, error: error)
    }
}

public struct HandleErrorsByShowingAlertViewModifier: ViewModifier {
    @StateObject public var errorHandling = ErrorHandling()

    public func body(content: Content) -> some View {
        content
            .environmentObject(errorHandling)
            // Applying the alert for error handling using a background element
            // is a workaround, if the alert would be applied directly,
            // other .alert modifiers inside of content would not work anymore
            .background(
                EmptyView()
                    .alert(item: $errorHandling.currentAlert) { currentAlert in
                        Alert(
                            title: Text("Error"),
                            message: Text(currentAlert.message),
                            dismissButton: .default(Text("Ok")) {
                                currentAlert.dismissAction?()
                            }
                        )
                    }
            )
    }
}

extension View {
    public func handlingErrors() -> some View {
        modifier(HandleErrorsByShowingAlertViewModifier())
    }
}
