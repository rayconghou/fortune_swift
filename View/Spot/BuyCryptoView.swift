//
//  BuyCryptoView.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/11/25.
//

import Foundation
import SwiftUI
import WebKit


// WebView Component
struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}


// Transak Buy Widget
struct BuyCryptoView: View {
    var body: some View {
        WebView(
          url: URL(string:
            "https://global-stg.transak.com?apiKey=27a00627-5f45-4ff6-a65e-b5cf06928992&environment=STAGING&productsAvailed=BUY&themeColor=#1E1E1E&hideMenu=true&defaultFiatCurrency=USD&cryptoCurrencyCode=ETH"
          )!
        )
            .edgesIgnoringSafeArea(.all)
    }
}

