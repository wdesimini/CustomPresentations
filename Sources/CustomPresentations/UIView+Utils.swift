//
//  File.swift
//  
//
//  Created by Wilson Desimini on 8/22/20.
//

#if canImport(UIKit)
import UIKit

extension UIView {
    func pinTo(_ parent: UIView) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parent.topAnchor),
            bottomAnchor.constraint(equalTo: parent.bottomAnchor),
            leftAnchor.constraint(equalTo: parent.leftAnchor),
            rightAnchor.constraint(equalTo: parent.rightAnchor)
        ])
    }
    
    static func performAnimations(
        _ animations: [() -> ()],
        duration: TimeInterval,
        completion: (() -> ())?
    ) {
        for (index, animation) in animations.enumerated() {
            animate(
                withDuration: duration,
                delay: duration * TimeInterval(index),
                options: .curveLinear,
                animations: animation
            ) { _ in
                if index == animations.count - 1 {
                    completion?()
                }
            }
        }
    }
}
#endif
