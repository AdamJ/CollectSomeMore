//
//  customFonts.swift
//  GamesAndThings
//
//  Created by Adam Jolicoeur on 3/21/25.
//  Copyright © 2025 AdamJolicoeur. All rights reserved.
//

import SwiftUI

extension View {
    func faPro(size: CGFloat) -> some View {
        self.font(.custom("FontAwesome6Pro-Regular", size: size))
    }

    func faProLight(size: CGFloat) -> some View {
        self.font(.custom("FontAwesome6Pro-Light", size: size))
    }

    func faProSolid(size: CGFloat) -> some View {
        self.font(.custom("FontAwesome6Pro-Solid", size: size))
    }

    func faProThin(size: CGFloat) -> some View {
        self.font(.custom("FontAwesome6Pro-Thin", size: size))
    }

    func faDuotone(size: CGFloat) -> some View {
        self.font(.custom("FontAwesome6Duotone-Solid", size: size))
    }

    func faSharp(size: CGFloat) -> some View {
        self.font(.custom("FontAwesome6Sharp-Regular", size: size))
    }

    func faSharpLight(size: CGFloat) -> some View {
        self.font(.custom("FontAwesome6Sharp-Light", size: size))
    }

    func faSharpSolid(size: CGFloat) -> some View {
        self.font(.custom("FontAwesome6Sharp-Solid", size: size))
    }

    func faBrands(size: CGFloat) -> some View {
        self.font(.custom("FontAwesome6Brands-Regular", size: size))
    }

    func faSharpThin(size: CGFloat) -> some View {
        self.font(.custom("FontAwesome6Sharp-Thin", size: size))
    }
}
