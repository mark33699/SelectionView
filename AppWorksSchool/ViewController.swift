//
//  ViewController.swift
//  AppWorksSchool
//
//  Created by iOS_Mark on 2020/2/10.
//  Copyright © 2020 IPK. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SelectionViewDataSource, SelectionViewDelegate
{
    enum ColorType: String
    {
        case red = "Red"
        case yellow = "Yellow"
        case green = "Green"
        case blue = "Blue"
        
        private var defaultButtonColor: UIColor { return .white }
        private var defaultButtonFont: UIFont { return .systemFont(ofSize: 18) }
        
        var color: UIColor
        {
            switch self
            {
                case .red: return .red
                case .yellow: return .yellow
                case .blue: return .blue
                case .green: return .green
            }
        }
        
        var buttonModel: SelectionView.ButtonModel
        {
            return .init(title: self.rawValue,
                         titleColor: defaultButtonColor,
                         titleFont: defaultButtonFont)
        }
    }
    
    private var shouldTapBottomSelectView: Bool = true
    
    //MARK: subview
    private let colorViewTop: UIView = .init()
    private let colorViewBottom: UIView = .init()
    private let selectViewTop: SelectionView = .init()
    private let selectViewBottom: SelectionView = .init()
    
    private var colorTypesBottom: Array<ColorType> = []
    private var colorTypesTop: Array<ColorType>
    {
        return [.red, .yellow]
    }
    
    //MARK: UI
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        colorTypesBottom = [.red, .yellow, .blue]
        
        selectViewTop.dataSource = self
        selectViewTop.delegate = self
        selectViewBottom.dataSource = self
        selectViewBottom.delegate = self
        
        layoutUI()
    }
    
    private func layoutUI()
    {
        colorViewTop.backgroundColor = colorTypesTop.first?.color
        colorViewBottom.backgroundColor = colorTypesBottom.first?.color
        
        let reloadButton = UIButton()
        reloadButton.setTitle("RELOAD!", for: .normal)
        reloadButton.setTitleColor(.red, for: .normal)
        reloadButton.addTarget(self, action: #selector(reload), for: .touchUpInside)
        
        let stackView = UIStackView.init(arrangedSubviews: [selectViewTop, colorViewTop, selectViewBottom, colorViewBottom, reloadButton])
        view.addSubview(stackView)
        let safeArea = view.safeAreaLayoutGuide
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 100).isActive = true
        stackView.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
    }
    
    //MARK: SelectionViewDataSource
    func numberOfButtons(in selectionView: SelectionView) -> Int
    {
        switch selectionView
        {
        case selectViewTop:
            return colorTypesTop.count
        case selectViewBottom:
            return colorTypesBottom.count
        default:
            print("numberOfButtons exception")
            return 0
        }
    }
    
    func selectionView(_ selectionView: SelectionView, buttonAt index: Int) -> SelectionView.ButtonModel
    {
        switch selectionView
        {
        case selectViewTop:
            return colorTypesTop[index].buttonModel
        case selectViewBottom:
            return colorTypesBottom[index].buttonModel
        default:
            print("selectionViewButton exception")
            return .init(title: "", titleColor: .white, titleFont: .systemFont(ofSize: 18))
        }
    }
    
    func indicatorColor(in selectionView: SelectionView) -> UIColor
    {
        return .white
    }
    
    //MARK: SelectionViewDelegate
    func selectionView(_ selectionView: SelectionView, shouldSelectAt index: Int) -> Bool
    {
        switch selectionView
        {
        case selectViewTop:
            return true
        case selectViewBottom:
            return shouldTapBottomSelectView
        default:
            print("selectionViewShouldSelect exception")
            return true
        }
    }
    
    func selectionView(_ selectionView: SelectionView, didSelectAt index: Int)
    {
        switch selectionView
        {
        case selectViewTop:
            colorViewTop.backgroundColor = colorTypesTop[index].color
            //如果上方的 SelectionView 目前選取的 button 是最後一個，那下方的 SelectionView 則不可以被使用者控制。
            shouldTapBottomSelectView = index == colorTypesTop.count - 1 ? false : true
        case selectViewBottom:
            colorViewBottom.backgroundColor = colorTypesBottom[index].color
        default:
            print("selectionViewDidSelect exception")
        }
    }
    
    //MARK: Seletor
    @objc func reload(btn: UIButton)
    {
        colorTypesBottom.append(.green)
        selectViewBottom.reloadData()
    }
}
