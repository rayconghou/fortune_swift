//
//  Fonts.swift
//  Dojo
//
//  Created by Raymond Hou on 3/31/25.
//

import SwiftUI

extension Font {
    // MARK: - Satoshi Font Family (Primary)
    
    /// Satoshi Regular - 16pt
    static let satoshiRegular = Font.custom("Satoshi-Regular", size: 16)
    
    /// Satoshi Regular - 14pt
    static let satoshiRegular14 = Font.custom("Satoshi-Regular", size: 14)
    
    /// Satoshi Regular - 12pt
    static let satoshiRegular12 = Font.custom("Satoshi-Regular", size: 12)
    
    /// Satoshi Regular - 18pt
    static let satoshiRegular18 = Font.custom("Satoshi-Regular", size: 18)
    
    /// Satoshi Regular - 20pt
    static let satoshiRegular20 = Font.custom("Satoshi-Regular", size: 20)
    
    /// Satoshi Regular - 24pt
    static let satoshiRegular24 = Font.custom("Satoshi-Regular", size: 24)
    
    /// Satoshi Regular - 28pt
    static let satoshiRegular28 = Font.custom("Satoshi-Regular", size: 28)
    
    /// Satoshi Regular - 32pt
    static let satoshiRegular32 = Font.custom("Satoshi-Regular", size: 32)
    
    /// Satoshi Regular - 48pt
    static let satoshiRegular48 = Font.custom("Satoshi-Regular", size: 48)
    
    /// Satoshi Regular - 54pt
    static let satoshiRegular54 = Font.custom("Satoshi-Regular", size: 54)
    
    // MARK: - Satoshi Medium
    
    /// Satoshi Medium - 16pt
    static let satoshiMedium = Font.custom("Satoshi-Medium", size: 16)
    
    /// Satoshi Medium - 14pt
    static let satoshiMedium14 = Font.custom("Satoshi-Medium", size: 14)
    
    /// Satoshi Medium - 18pt
    static let satoshiMedium18 = Font.custom("Satoshi-Medium", size: 18)
    
    /// Satoshi Medium - 20pt
    static let satoshiMedium20 = Font.custom("Satoshi-Medium", size: 20)
    
    /// Satoshi Medium - 24pt
    static let satoshiMedium24 = Font.custom("Satoshi-Medium", size: 24)
    
    /// Satoshi Medium - 28pt
    static let satoshiMedium28 = Font.custom("Satoshi-Medium", size: 28)
    
    /// Satoshi Medium - 32pt
    static let satoshiMedium32 = Font.custom("Satoshi-Medium", size: 32)
    
    // MARK: - Satoshi Bold
    
    /// Satoshi Bold - 16pt
    static let satoshiBold = Font.custom("Satoshi-Bold", size: 16)
    
    /// Satoshi Bold - 14pt
    static let satoshiBold14 = Font.custom("Satoshi-Bold", size: 14)
    
    /// Satoshi Bold - 18pt
    static let satoshiBold18 = Font.custom("Satoshi-Bold", size: 18)
    
    /// Satoshi Bold - 20pt
    static let satoshiBold20 = Font.custom("Satoshi-Bold", size: 20)
    
    /// Satoshi Bold - 24pt
    static let satoshiBold24 = Font.custom("Satoshi-Bold", size: 24)
    
    /// Satoshi Bold - 28pt
    static let satoshiBold28 = Font.custom("Satoshi-Bold", size: 28)
    
    /// Satoshi Bold - 32pt
    static let satoshiBold32 = Font.custom("Satoshi-Bold", size: 32)
    
    /// Satoshi Bold - 48pt
    static let satoshiBold48 = Font.custom("Satoshi-Bold", size: 48)
    
    /// Satoshi Bold - 54pt
    static let satoshiBold54 = Font.custom("Satoshi-Bold", size: 54)
    
    // MARK: - Satoshi Light
    
    /// Satoshi Light - 14pt
    static let satoshiLight14 = Font.custom("Satoshi-Light", size: 14)
    
    /// Satoshi Light - 16pt
    static let satoshiLight16 = Font.custom("Satoshi-Light", size: 16)
    
    /// Satoshi Light - 18pt
    static let satoshiLight18 = Font.custom("Satoshi-Light", size: 18)
    
    // MARK: - Satoshi Black
    
    /// Satoshi Black - 24pt
    static let satoshiBlack24 = Font.custom("Satoshi-Black", size: 24)
    
    /// Satoshi Black - 28pt
    static let satoshiBlack28 = Font.custom("Satoshi-Black", size: 28)
    
    /// Satoshi Black - 32pt
    static let satoshiBlack32 = Font.custom("Satoshi-Black", size: 32)
    
    /// Satoshi Black - 48pt
    static let satoshiBlack48 = Font.custom("Satoshi-Black", size: 48)
    
    /// Satoshi Black - 54pt
    static let satoshiBlack54 = Font.custom("Satoshi-Black", size: 54)
    
    // MARK: - Degen Fonts (The Last Shuriken - Ninja Font)
    
    /// The Last Shuriken - 16pt (Degen only)
    static let ninjaRegular = Font.custom("The Last Shuriken", size: 16)
    
    /// The Last Shuriken - 18pt (Degen only)
    static let ninja18 = Font.custom("The Last Shuriken", size: 18)
    
    /// The Last Shuriken - 20pt (Degen only)
    static let ninja20 = Font.custom("The Last Shuriken", size: 20)
    
    /// The Last Shuriken - 24pt (Degen only)
    static let ninja24 = Font.custom("The Last Shuriken", size: 24)
    
    /// The Last Shuriken - 28pt (Degen only)
    static let ninja28 = Font.custom("The Last Shuriken", size: 28)
    
    /// The Last Shuriken - 32pt (Degen only)
    static let ninja32 = Font.custom("The Last Shuriken", size: 32)
    
    /// The Last Shuriken - 48pt (Degen only)
    static let ninja48 = Font.custom("The Last Shuriken", size: 48)
    
    /// The Last Shuriken - 54pt (Degen only)
    static let ninja54 = Font.custom("The Last Shuriken", size: 54)
}

// MARK: - Font Usage Guidelines
/*
 
 FONT USAGE GUIDELINES:
 
 1. REGULAR UI (Non-Degen):
    - Use Satoshi font family for all regular UI elements
    - Use .satoshiRegular, .satoshiMedium, .satoshiBold, etc.
    - Never use The Last Shuriken outside of degen sections
 
 2. DEGEN MODE ONLY:
    - Use .ninjaRegular, .ninja18, .ninja24, etc. for degen-specific UI
    - Only use in View/Degen/ folder and related components
    - Use sparingly for maximum impact
 
 3. SYSTEM FONTS:
    - Use .system() only for SF Symbols and system UI elements
    - Avoid .system() for text content - use Satoshi instead
 
 */
