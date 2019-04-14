//
//  OnboardingSliderViewController.swift
//  Self
//
//  Created by Jamie on 12/04/2019.
//  Copyright © 2019 Jamie De Vivo. All rights reserved.
//

import UIKit

class OnboardingSliderViewController: ViewController {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.tintColor = UIColor.app.interactive.selectable.selected()
        pageControl.pageIndicatorTintColor = UIColor.app.interactive.selectable.unselected()
        pageControl.currentPageIndicatorTintColor = UIColor.app.interactive.selectable.selected()
        return pageControl
    }()
    
    lazy var nameOnboardingController: NameOnboardingViewController = {
        let viewController = NameOnboardingViewController()
        self.addChild(viewController)
        return viewController
    }()
    
    lazy var inductionOnboardingViewController: InductionOnboardingViewController = {
        let viewController = InductionOnboardingViewController()
        self.addChild(viewController)
        return viewController
    }()
    weak var onboardingManagerDelegate: OnboardingViewController?

}
    
// MARK: - Overrides
extension OnboardingSliderViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        addSubViews()
        addConstraints()
        setupSlider(onboardingStages: [nameOnboardingController, inductionOnboardingViewController])
        nameOnboardingController.onboardingFlowDelegate = self
        inductionOnboardingViewController.onboardingFlowDelegate = self
    }
}

// MARK: - Functions
extension OnboardingSliderViewController: UIScrollViewDelegate {
    func setupSlider(onboardingStages stages: [ViewController]) {
        pageControl.numberOfPages = stages.count
        pageControl.currentPage = 0
        
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(stages.count), height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< stages.count {
            let stageController = stages[i]
            addChildViewController(viewController: stageController)
            scrollView.addSubview(stageController.view)
            stageController.view.frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}

extension OnboardingSliderViewController: OnboardingFlowDelegate {
    func nextStage() {
        print("Next Stage")
        guard pageControl.currentPage < (pageControl.numberOfPages - 1) else {
            onboardingManagerDelegate?.continueOnboarding()
            return
        }
        pageControl.currentPage = pageControl.currentPage + 1
        scrollView.setContentOffset(CGPoint(x: (scrollView.frame.width * CGFloat(pageControl.currentPage)), y: scrollView.contentOffset.y), animated: true)
        
    }
    func previousStage() {
        guard pageControl.currentPage > 0 else { return }
        pageControl.currentPage = pageControl.currentPage - 1
        scrollView.setContentOffset(CGPoint(x: (scrollView.frame.width * CGFloat(pageControl.currentPage)), y: scrollView.contentOffset.y), animated: true)
    }
}

extension OnboardingSliderViewController: ViewBuilding, AddingChildViewControllers {
    
    func addChildViewController(viewController: UIViewController) {
        addChild(viewController)
        viewController.didMove(toParent: self)
    }
    
    func addSubViews() {
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        view.bringSubviewToFront(pageControl)
    }
    
    func addConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(pageControl.snp.top).offset(10)
        }
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-25)
            make.centerX.equalToSuperview()
            make.height.equalTo(10)
        }
    }
}

