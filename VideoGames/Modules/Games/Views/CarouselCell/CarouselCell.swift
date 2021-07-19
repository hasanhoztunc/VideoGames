//
//  CarouselCell.swift
//  VideoGames
//
//  Created by Hasan Oztunc on 19.07.2021.
//

import UIKit

import RxSwift
import RxCocoa

import SDWebImage

final class CarouselCell: UICollectionViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var pageControl: UIPageControl!
    
    private let bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(usingViewModel viewModel: [CarouselCellViewPresentable]) {
        scrollView.removeConstraints(scrollView.constraints)
        scrollView.translatesAutoresizingMaskIntoConstraints = true
        
        scrollView.contentSize = CGSize(width: (containerView.frame.size.width * 3), height: containerView.frame.size.height)
        
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        
        for (index, game) in viewModel.enumerated() {
            let imageView = UIImageView(frame: CGRect(
                                            x: scrollView.frame.size.width * CGFloat(index),
                                            y: 0,
                                            width: scrollView.frame.size.width,
                                            height: scrollView.frame.size.height))
            imageView.sd_setImage(with: game.photo)
            
            scrollView.addSubview(imageView)
        }
        
        scrollView
            .rx
            .didScroll
            .map({ [weak self] in
                guard let self = self else { return }
                let width = self.scrollView.bounds.size.width
                let page = Int((self.scrollView.contentOffset.x + width / 2) / width)
                
                self.pageControl.currentPage = page
            })
            .subscribe()
            .disposed(by: bag)
    }
}
