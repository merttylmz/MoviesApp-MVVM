//
//  Extensions.swift
//  MoviesApp-MVVM
//
//  Created by Mert Yılmaz on 29.08.2024.
//

import Foundation

extension String {
    
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
}
