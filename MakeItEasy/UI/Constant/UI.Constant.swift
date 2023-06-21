//
//  UIConsant.swift
//  MakeItEasy
//
//  Created by Brian Seo on 2023-06-13.
//

import SwiftUI

struct UI {
    struct Constant {
        static func ScanButton(_ color: Color) -> some View {
            ZStack {
                Circle()
                    .strokeBorder(color, lineWidth: 3)
                    .frame(width: 62, height: 62)
                Circle()
                    .fill(color)
                    .frame(width: 50, height: 50)
            }
        }
    }
}
