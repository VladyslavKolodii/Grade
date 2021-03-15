//
//  UIImageViewExtension.swift
//  Grading
//
//  Created by Aira on 16.03.2021.
//

import Foundation
import Kingfisher

extension UIImageView {
    func loadImage(url: String) {
        let processor = DownsamplingImageProcessor(size: self.frame.size)
            |> RoundCornerImageProcessor(cornerRadius: 0)
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: URL(string: url),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
}
