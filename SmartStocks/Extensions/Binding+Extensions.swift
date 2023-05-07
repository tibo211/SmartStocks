//
//  Binding+Extensions.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-07.
//

import SwiftUI

extension Binding {
    func optionalFlag<T>() -> Binding<Bool> where Value == T? {
        Binding<Bool> {
            wrappedValue != nil
        } set: { isActive in
            if !isActive {
                wrappedValue = nil
            }
        }
    }
}
