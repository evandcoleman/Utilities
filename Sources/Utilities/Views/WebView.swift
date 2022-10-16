//
//  WebView.swift
//  
//
//  Created by Evan Coleman on 6/8/22.
//

#if canImport(SwiftUI)
import SwiftUI
import WebKit

public struct WebView: UIViewRepresentable {

    var urlRequest: URLRequest
    var currentURLRequest: Binding<URLRequest?>?
    var configuration: WKWebViewConfiguration
    var configure: ((WKWebView) -> Void)?

    public init(urlRequest: URLRequest, currentURLRequest: Binding<URLRequest?>? = nil, configuration: WKWebViewConfiguration, configure: ((WKWebView) -> Void)? = nil) {
        self.urlRequest = urlRequest
        self.currentURLRequest = currentURLRequest
        self.configuration = configuration
        self.configure = configure
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(currentURLRequest: currentURLRequest)
    }

    public func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero, configuration: configuration)
        configure?(webView)
        webView.load(urlRequest)

        return webView
    }

    public func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.navigationDelegate = context.coordinator
    }
}

extension WebView {
    public final class Coordinator: NSObject, WKNavigationDelegate {

        var currentURLRequest: Binding<URLRequest?>?

        init(currentURLRequest: Binding<URLRequest?>?) {
            self.currentURLRequest = currentURLRequest
        }

        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

            currentURLRequest?.wrappedValue = navigationAction.request
            decisionHandler(.allow)
        }
    }
}
#endif
