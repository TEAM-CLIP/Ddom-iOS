//
//  Font+.swift
//  Ddom
//
//  Created by 김 형석 on 10/15/24.
//
import Foundation
import SwiftUI

extension Font {
    static let heading = Font.custom("Pretendard-Bold", size: 28)
    static let title1 = Font.custom("Pretendard-Bold", size: 20)
    static let title2 = Font.custom("Pretendard-SemiBold", size: 18)
    static let body1 = Font.custom("Pretendard-Bold", size: 16)
    static let body2 = Font.custom("Pretendard-Medium", size: 16)
    static let body3 = Font.custom("Pretendard-Medium", size: 14)
    static let caption = Font.custom("Pretendard-Medium", size: 12)
    
    var lineSpacing: CGFloat {
        switch self {
        case .heading:
            return 42 - 28
        case .title1:
            return 30 - 20
        case .title2:
            return 24 - 18
        case .body1, .body2:
            return 24 - 16
        case .body3:
            return 22 - 14
        case .caption:
            return 16 - 12
        default:
            return 0
        }
    }
    
    var letterSpacing: CGFloat {
        switch self {
        case .heading, .title1:
            return -1.5
        case .title2, .body1, .body2, .body3:
            return -0.25
        case .caption:
            return 0
        default:
            return 0
        }
    }
}
