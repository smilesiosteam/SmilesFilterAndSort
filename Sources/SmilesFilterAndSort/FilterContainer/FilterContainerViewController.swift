//
//  FilterContainerViewController.swift
//  
//
//  Created by Ahmed Naguib on 31/10/2023.
//

import UIKit
import Combine

public final class FilterContainerViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var clearAllButton: UIButton!
    @IBOutlet private weak var filterLabel: UILabel!
    @IBOutlet private weak var filterCountLabel: UILabel!
    @IBOutlet private weak var applyLabel: UILabel!
    @IBOutlet private weak var viewFilter: UIView!
    @IBOutlet private weak var segmentController: UISegmentedControl!
    
    let filterViewController = SortViewController.create()
    let choicesViewController  = FilterChoicesVC()
    
    
    private let viewModel = FilterContainerViewModel()
    let demo = DemoViewController()
    var cancellable = Set<AnyCancellable>()
    
    var dic: [String: [String]] = [:]
    public override func viewDidLoad() {
        super.viewDidLoad()
        filterViewController.view.frame = self.containerView.bounds
        demo.view.frame = self.containerView.bounds
        viewModel.fetchFilters()
        segmentController.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        let normalColor = UIColor.black.withAlphaComponent(0.6)
        segmentController.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: normalColor], for: .normal)
        viewFilter.layer.cornerRadius = 24
        
        bindCountFilters()
       
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        containerView.addSubview(filterViewController.view)
        containerView.addSubview(demo.view)
        containerView.bringSubviewToFront(filterViewController.view)
        filterViewController.setupSections(filterModel: FilterUIModel(sections: viewModel.filters))
        choicesViewController.updateData(section: viewModel.cuisines[0])
        bindFilterData()
    }
    
    private func bindCountFilters() {
        viewModel.$countOfSelectedFilters.sink { [weak self] count in
            self?.filterCountLabel.text = "\(count)"
        }
        .store(in: &cancellable)
    }
    
    private func bindFilterCuision() {
        
    }
    
    private func bindFilterData() {
        filterViewController.selectedFilter.sink { [weak self] indexPath in
            guard let self else {
                return
            }
            self.viewModel.updateFilter(with: indexPath)
//            self.filterCountLabel.text = "\(self.viewModel.getSelectedFilters())"
            self.viewModel.updateSelectedFilters()
        }.store(in: &cancellable)
    }
    
    @IBAction func filterTapped(_ sender: Any) {
        
//        print(viewModel.getSelectedFilters())
    }
    
    
    @IBAction func dismissTapped(_ sender: Any) {
    }
    @IBAction func clearAllTapped(_ sender: Any) {
    }
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if segmentController.selectedSegmentIndex == 0 {
            filterViewController.view.alpha = 0
            containerView.bringSubviewToFront(filterViewController.view)
            fadeIn(view: filterViewController.view)
        } else {
            demo.view.alpha = 0
            containerView.bringSubviewToFront(demo.view)
            fadeIn(view: demo.view)
        }
    }
    
    
    func fadeIn(view: UIView, duration: TimeInterval = 0.5) {
            UIView.animate(withDuration: duration) {
                view.alpha = 1.0 // Set the final alpha value to 1 for a full fade-in
            }
        }
    

}

extension FilterContainerViewController {
    static public func create() -> UIViewController {
        let viewController = FilterContainerViewController(nibName: String(describing: FilterContainerViewController.self), bundle: .module)
        return viewController
    }
}


class DemoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}

import UIKit

class CustomizableSegmentControl: UISegmentedControl {
    
    private(set) lazy var radius:CGFloat = bounds.height / 2
    
    /// Configure selected segment inset, can't be zero or size will error when click segment
    private var segmentInset: CGFloat = 0.1{
        didSet{
            if segmentInset == 0{
                segmentInset = 0.1
            }
        }
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        selectedSegmentIndex = 0
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func layoutSubviews(){
        super.layoutSubviews()
        self.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        
        //MARK: - Configure Background Radius
        self.layer.cornerRadius = self.radius
        self.layer.masksToBounds = true

        //MARK: - Find selectedImageView
        let selectedImageViewIndex = numberOfSegments
        if let selectedImageView = subviews[selectedImageViewIndex] as? UIImageView {
            //MARK: - Configure selectedImageView Color
            selectedImageView.backgroundColor = .white
            selectedImageView.image = nil
            
            //MARK: - Configure selectedImageView Inset with SegmentControl
            selectedImageView.bounds = selectedImageView.bounds.insetBy(dx: 7, dy: 6)
//            selectedImageView.
            //MARK: - Configure selectedImageView cornerRadius
            selectedImageView.layer.masksToBounds = true
            selectedImageView.layer.cornerRadius = (bounds.height - 6) / 2
            
            selectedImageView.layer.removeAnimation(forKey: "SelectionBounds")

        }
       
    }
   
}
