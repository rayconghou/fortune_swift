//
//  PortfolioView.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/11/25.
//

import Foundation
import SwiftUI

struct PortfolioView: View {
    // Stub asset data
    let assets = [
        Asset(name: "Bitcoin", symbol: "BTC", amount: 1.0, value: 0.0)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Your Portfolio")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                if assets.isEmpty || assets[0].amount == 0.0 {
                    VStack(spacing: 20) {
                        Image(systemName: "briefcase")
                            .resizable()
                            .frame(width: 70, height: 60)
                            .foregroundColor(.gray)
                            .padding(.top, 40)
                        Text("No Assets Yet")
                            .font(.title2)
                            .foregroundColor(.white)
                        Text("Start your crypto journey by purchasing your first coin.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 40)
                        Button(action: {
                            // Navigate to buy screen if needed
                        }) {
                            Text("Buy Crypto")
                                .fontWeight(.bold)
                                .padding()
                                .frame(width: 200)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top, 20)
                    }
                    .padding(.vertical, 50)
                } else {
                    VStack(spacing: 15) {
                        Text("Total Balance")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("$0.00")
                            .font(.system(size: 42, weight: .bold))
                            .foregroundColor(.white)
                        HStack {
                            Text("+$0.00")
                                .font(.headline)
                                .foregroundColor(.green)
                            Text("(0.00%)")
                                .font(.headline)
                                .foregroundColor(.green)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    Text("Your Assets")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    
                    ForEach(assets) { asset in
                        AssetRow(asset: asset)
                    }
                }
                Spacer()
            }
        }
        .background(Color.black)
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .preferredColorScheme(.dark)
    }
}
