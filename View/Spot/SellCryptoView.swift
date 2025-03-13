//
//  SellCryptoView.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/11/25.
//

import Foundation
import SwiftUI

struct SellCryptoView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedCoin = "No Assets"
    @State private var amount = ""
    @State private var depositMethod = "Custodial Wallet"
    
    // Stub for available assets
    let availableCoins = ["No Assets"]
    let depositMethods = ["Custodial Wallet", "Bank Account"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                Text("Sell Cryptocurrency")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                if availableCoins == ["No Assets"] {
                    VStack(spacing: 20) {
                        Image(systemName: "wallet.pass")
                            .resizable()
                            .frame(width: 60, height: 50)
                            .foregroundColor(.gray)
                        Text("No Assets Available")
                            .font(.title2)
                            .foregroundColor(.white)
                        Text("You don't have any crypto assets to sell at the moment. Purchase some first!")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                    .padding(40)
                } else {
                    VStack(alignment: .leading) {
                        Text("Select Asset")
                            .foregroundColor(.gray)
                        Picker("Asset", selection: $selectedCoin) {
                            ForEach(availableCoins, id: \.self) { coin in
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
                        Text("Deposit To")
                            .foregroundColor(.gray)
                        Picker("Deposit Method", selection: $depositMethod) {
                            ForEach(depositMethods, id: \.self) { method in
                                Text(method).tag(method)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .foregroundColor(.gray)
                        .padding(.bottom, 30)
                }
            }
            .background(Color.black)
            .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
    }
}
