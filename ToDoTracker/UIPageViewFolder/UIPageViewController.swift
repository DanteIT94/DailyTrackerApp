//
//  UIPageViewController.swift
//  ToDoTracker
//
//  Created by Денис on 24.07.2023.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    
    lazy var pages: [UIViewController] = {
        let firstPage = UIViewController()
        let firstImageView = UIImageView(image: UIImage(named: "PageImageView1"))
        firstImageView.contentMode = .scaleAspectFill
        firstPage.view.addSubview(firstImageView)
        firstImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            firstImageView.leadingAnchor.constraint(equalTo: firstPage.view.leadingAnchor),
            firstImageView.trailingAnchor.constraint(equalTo: firstPage.view.trailingAnchor),
            firstImageView.topAnchor.constraint(equalTo: firstPage.view.topAnchor),
            firstImageView.bottomAnchor.constraint(equalTo: firstPage.view.bottomAnchor)
        ])
        
        let secondPage = UIViewController()
        let secondImageView = UIImageView(image: UIImage(named: "PageImageView2"))
        secondImageView.contentMode = .scaleAspectFill
        secondPage.view.addSubview(secondImageView)
        secondImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secondImageView.leadingAnchor.constraint(equalTo: secondPage.view.leadingAnchor),
            secondImageView.trailingAnchor.constraint(equalTo: secondPage.view.trailingAnchor),
            secondImageView.topAnchor.constraint(equalTo: secondPage.view.topAnchor),
            secondImageView.bottomAnchor.constraint(equalTo: secondPage.view.bottomAnchor)
        ])
        
        return [firstPage, secondPage]
    }()
    
    let pageTexts = ["Отслеживайте только то, что хотите", "Даже если это не литры воды и йога"]
    
    var currentPageIndex = 0
    
    lazy var onboardingLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var pageControl: UIPageControl = {
        
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        return pageControl
    }()
    
    lazy var onboardingButton: UIButton = {
       let button = UIButton()
        button.setTitle("Вот это технология!", for: .normal)
        button.backgroundColor = .YPBlack
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        
        configLayout()
        updateOnboardingLabel()
    }
    
    //MARK: - Private Methods
    private func configLayout() {
        
        [onboardingButton, pageControl, onboardingLabel].forEach{
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            onboardingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            onboardingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 62),
            onboardingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            onboardingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 8),
            pageControl.bottomAnchor.constraint(equalTo: onboardingButton.topAnchor, constant: -10),
            //Кнопка
            onboardingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            onboardingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            onboardingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            onboardingButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        
    }
    
    private func updateOnboardingLabel() {
        guard currentPageIndex >= 0, currentPageIndex < pageTexts.count else
        { return }
        onboardingLabel.text = pageTexts[currentPageIndex]
    }
    
}

//MARK: -UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    //Возвращает предыдущий контроллер
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if viewControllerIndex == 0 {
            return pages.last
        }
        
        let previousIndex = viewControllerIndex - 1
        return pages[previousIndex]
    }
    
    //Возвращает следующий вьюконтроллер
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        if viewControllerIndex == pages.count - 1 {
            return pages.first
        }
        
        let nextIndex = viewControllerIndex + 1
        return pages[nextIndex]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed,
            let currentViewController = pageViewController.viewControllers?.first,
            let currentIndex = pages.firstIndex(of: currentViewController) {
            currentPageIndex = currentIndex
            updateOnboardingLabel()
            pageControl.currentPage = currentIndex
        }
    }
    
}
