//
//  UIConsant.swift
//  MakeItEasy
//
//  Created by Brian Seo on 2023-06-13.
//

import SwiftUI

struct UI {
    struct Constant {
        static func ScanButton() -> some View {
            ZStack {
                Circle()
                    .strokeBorder(.primary, lineWidth: 3)
                    .frame(width: 62, height: 62)
                Circle()
                    .fill(.primary)
                    .frame(width: 50, height: 50)
            }
            .foregroundColor(.primary)
        }
    }
}
