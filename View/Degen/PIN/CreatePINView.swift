//
//  CreatePINView.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/31/25.
//

import Foundation
import SwiftUI

struct CreatePINView: View {
    @ObservedObject var viewModel: SecureSignInFlowViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                    .symbolEffect(.pulse, options: .repeating)
                
                Text("Create Your PIN")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Choose a secure 6-digit PIN to protect your assets.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
            
            Spacer().frame(height: 40)
            
            // PIN Dots
            HStack(spacing: 16) {
                ForEach(0..<6, id: \.self) { index in
                    PinDot(isFilled: index < viewModel.pin.count, error: false)
                }
            }
            
            if viewModel.showPin && !viewModel.pin.isEmpty {
                Text(viewModel.pin)
                    .font(.title3)
                    .foregroundColor(.blue)
                    .padding(.top, 8)
                    .transition(.opacity)
            }
            
            Spacer()
            
            numberPad
                .padding(.bottom)
        }
        .padding()
    }
    
    var numberPad: some View {
        VStack(spacing: 12) {
            HStack(spacing: 24) {
                NumberPadButton(number: "1") { viewModel.appendPin(digit: "1") }
                NumberPadButton(number: "2") { viewModel.appendPin(digit: "2") }
                NumberPadButton(number: "3") { viewModel.appendPin(digit: "3") }
            }
            
            HStack(spacing: 24) {
                NumberPadButton(number: "4") { viewModel.appendPin(digit: "4") }
                NumberPadButton(number: "5") { viewModel.appendPin(digit: "5") }
                NumberPadButton(number: "6") { viewModel.appendPin(digit: "6") }
            }
            
            HStack(spacing: 24) {
                NumberPadButton(number: "7") { viewModel.appendPin(digit: "7") }
                NumberPadButton(number: "8") { viewModel.appendPin(digit: "8") }
                NumberPadButton(number: "9") { viewModel.appendPin(digit: "9") }
            }
            
            HStack(spacing: 24) {
                Button(action: { viewModel.showPin.toggle() }) {
                    ZStack {
                        Circle()
                            .fill(Color.black.opacity(0.1))
                            .overlay(
                                Circle()
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                        Image(systemName: viewModel.showPin ? "eye.fill" : "eye.slash.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
                .frame(width: 70, height: 70)
                .buttonStyle(ScaleButtonStyle())
                
                NumberPadButton(number: "0") { viewModel.appendPin(digit: "0") }
                
                Button(action: { viewModel.deleteLastDigit() }) {
                    ZStack {
                        Circle()
                            .fill(Color.black.opacity(0.1))
                            .overlay(
                                Circle()
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                        Image(systemName: "delete.left")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
                .frame(width: 70, height: 70)
                .buttonStyle(ScaleButtonStyle())
            }
        }
    }
}
