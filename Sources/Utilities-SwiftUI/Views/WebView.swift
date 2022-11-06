//
//  WebView.swift
//  
//
//  Created by Evan Coleman on 6/8/22.
//

#if canImport(SwiftUI) && canImport(UIKit)
import SwiftUI
import UIKit
import WebKit

public struct WebView: UIViewRepresentable {

    public enum Content {
        case urlRequest(URLRequest)
        case htmlString(String, baseURL: URL? = nil)
    }

    var content: Content
    var currentURLRequest: Binding<URLRequest?>?
    var configuration: WKWebViewConfiguration
    var configure: ((WKWebView) -> Void)?

    public init(htmlString: String, baseURL: URL? = nil, currentURLRequest: Binding<URLRequest?>? = nil, configuration: WKWebViewConfiguration = .init(), configure: ((WKWebView) -> Void)? = nil) {
        self.init(
            content: .htmlString(htmlString, baseURL: baseURL),
            currentURLRequest: currentURLRequest,
            configuration: configuration,
            configure: configure
        )
    }

    public init(url: URL, currentURLRequest: Binding<URLRequest?>? = nil, configuration: WKWebViewConfiguration = .init(), configure: ((WKWebView) -> Void)? = nil) {
        self.init(
            urlRequest: URLRequest(url: url),
            currentURLRequest: currentURLRequest,
            configuration: configuration,
            configure: configure
        )
    }

    public init(urlRequest: URLRequest, currentURLRequest: Binding<URLRequest?>? = nil, configuration: WKWebViewConfiguration = .init(), configure: ((WKWebView) -> Void)? = nil) {
        self.init(
            content: .urlRequest(urlRequest),
            currentURLRequest: currentURLRequest,
            configuration: configuration,
            configure: configure
        )
    }

    public init(content: Content, currentURLRequest: Binding<URLRequest?>? = nil, configuration: WKWebViewConfiguration = .init(), configure: ((WKWebView) -> Void)? = nil) {
        self.content = content
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
        switch content {
        case .urlRequest(let request):
            webView.load(request)
        case .htmlString(let htmlString, let baseURL):
            webView.loadHTMLString(htmlString, baseURL: baseURL)
        }

        return webView
    }

    public func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.navigationDelegate == nil {
            uiView.navigationDelegate = context.coordinator
        }
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
