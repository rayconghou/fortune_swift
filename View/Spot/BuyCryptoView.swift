//
//  BuyCryptoView.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/11/25.
//

import Foundation
import SwiftUI

struct BuyCryptoView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedCoin = "Bitcoin"
    @State private var amount = ""
    @State private var paymentMethod = "Custodial Wallet"
    
    let coins = ["Bitcoin", "Ethereum", "Solana"]
    let paymentMethods = ["Custodial Wallet", "Apple Pay", "Bank Transfer"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                Text("Buy Cryptocurrency")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                VStack(alignment: .leading) {
                    Text("Select Coin")
                        .foregroundColor(.gray)
                    Picker("Coin", selection: $selectedCoin) {
                        ForEach(coins, id: \.self) { coin in
                            Text(coin).tag(coin)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                VStack(alignment: .leading) {
                    Text("Enter Amount")
                        .foregroundColor(.gray)
                    HStack {
                        Text("$")
                            .foregroundColor(.white)
                            .font(.title)
                        TextField("0.00", text: $amount)
                            .keyboardType(.decimalPad)
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                VStack(alignment: .leading) {
                    Text("Payment Method")
                        .foregroundColor(.gray)
                    Picker("Payment Method", selection: $paymentMethod) {
                        ForEach(paymentMethods, id: \.self) { method in
                            Text(method).tag(method)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                Spacer()
                Button(action: {
                    // Process purchase action
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Confirm Purchase")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(15)
                        .padding(.horizontal)
                }
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 30)
            }
            .background(Color.black)
            .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
    }
}
