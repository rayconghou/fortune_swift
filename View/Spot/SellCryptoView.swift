//
//  SellCryptoView.swift
//  Dojo
//
//  Created by Raymond Hou on 3/11/25.
//

import Foundation
import SwiftUI
import WebKit

// Transak Sell Widget
struct SellCryptoView: View {
    var body: some View {
        WebView(url: URL(string: "https://global-stg.transak.com?apiKey=27a00627-5f45-4ff6-a65e-b5cf06928992&environment=STAGING&productsAvailed=SELL")!)
            .edgesIgnoringSafeArea(.all)
    }
}
