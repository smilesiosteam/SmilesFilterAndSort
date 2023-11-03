//
//  FilterContainerViewController.swift
//  
//
//  Created by Ahmed Naguib on 31/10/2023.
//

import UIKit
import Combine
import SmilesUtilities

public final class FilterContainerViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel! { didSet { titleLabel.fontTextStyle = .smilesHeadline3 } }
    @IBOutlet private weak var clearAllButton: UIButton! { didSet { clearAllButton.fontTextStyle = .smilesTitle2 } }
    @IBOutlet private weak var filterLabel: UILabel! { didSet { filterLabel.fontTextStyle = .smilesTitle3 } }
    @IBOutlet private weak var filterCountLabel: UILabel! { didSet { filterCountLabel.fontTextStyle = .smilesTitle3 } }
    @IBOutlet private weak var applyLabel: UILabel! { didSet { applyLabel.fontTextStyle = .smilesTitle1 } }
    @IBOutlet private weak var viewFilter: UIView!
    @IBOutlet private weak var segmentController: UISegmentedControl!
    
    @IBOutlet weak var buttomView: UIView!
    let filterViewController = SortViewController.create()
    let choicesViewController  = FilterChoicesVC.create()
    
    
    private let viewModel = FilterContainerViewModel()
    
    var cancellable = Set<AnyCancellable>()
    
    var dic: [String: [String]] = [:]
    public override func viewDidLoad() {
        super.viewDidLoad()
        filterViewController.view.frame = self.containerView.bounds
        choicesViewController.view.frame = self.containerView.bounds
        viewModel.fetchFilters()
//        smilesTitle2
        let fontStyle = UIFont.preferredFont(forTextStyle: .smilesHeadline1)
        segmentController.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.foodEnableColor, NSAttributedString.Key.font: fontStyle], for: .selected)
        
        let normalColor = UIColor.black.withAlphaComponent(0.6)
        segmentController.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: normalColor, NSAttributedString.Key.font: fontStyle], for: .normal)
        viewFilter.layer.cornerRadius = 24
        
        bindCountFilters()
            
        clearAllButton.titleLabel?.textColor = .foodEnableColor
        
        buttomView.addShadowToSelf(offset: CGSize(width: 0, height: -1), color: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2), radius: 1.0, opacity: 5)
        
       
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        containerView.addSubview(filterViewController.view)
        containerView.addSubview(choicesViewController.view)
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
        choicesViewController.selectedFilter.sink { [weak self] indexPath in
            guard let self else {
                return
            }
            self.viewModel.updateCusines(with: indexPath)
            self.viewModel.updateSelectedFilters()
        }.store(in: &cancellable)
    }
    
    private func bindFilterData() {
        filterViewController.selectedFilter.sink { [weak self] indexPath in
            guard let self else {
                return
            }
            self.viewModel.updateFilter(with: indexPath)
            self.viewModel.updateSelectedFilters()
        }.store(in: &cancellable)
    }
    
    @IBAction func filterTapped(_ sender: Any) {
        
    }
    @IBAction func dismissTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func clearAllTapped(_ sender: Any) {
        filterViewController.clearData()
        viewModel.clearData()
        
    }
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if segmentController.selectedSegmentIndex == 0 {
            filterViewController.view.alpha = 0
            containerView.bringSubviewToFront(filterViewController.view)
            fadeIn(view: filterViewController.view)
        } else {
            choicesViewController.view.alpha = 0
            containerView.bringSubviewToFront(choicesViewController.view)
            fadeIn(view: choicesViewController.view)
        }
    }
    
    
    func fadeIn(view: UIView, duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration) {
            view.alpha = 1.0
        }
    }
}

extension FilterContainerViewController {
    static public func create() -> UIViewController {
        let viewController = FilterContainerViewController(nibName: String(describing: FilterContainerViewController.self), bundle: .module)
        return viewController
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
