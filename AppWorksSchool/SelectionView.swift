//
//  SelectionView.swift
//  AppWorksSchool
//
//  Created by iOS_Mark on 2020/2/10.
//  Copyright © 2020 IPK. All rights reserved.
//

import UIKit

protocol SelectionViewDataSource: AnyObject
{
    func indicatorColor(in selectionView: SelectionView) -> UIColor
    func numberOfButtons(in selectionView: SelectionView) -> Int
    func selectionView(_ selectionView: SelectionView, buttonAt index: Int) -> SelectionView.ButtonModel
}

extension SelectionViewDataSource
{
    func indicatorColor(in selectionView: SelectionView) -> UIColor
    {
        return .blue
    }
    
    func numberOfButtons(in selectionView: SelectionView) -> Int
    {
        return 2
    }
    
    func selectionView(_ selectionView: SelectionView, buttonAt index: Int) -> SelectionView.ButtonModel
    {
        return .init(title: "", titleColor: .white, titleFont: .systemFont(ofSize: 18))
    }
}

@objc
protocol SelectionViewDelegate: AnyObject
{
    @objc optional func selectionView(_ selectionView: SelectionView, didSelectAt index: Int)
    @objc optional func selectionView(_ selectionView: SelectionView, shouldSelectAt index: Int) -> Bool
}

class SelectionView: UIView
{
    struct ButtonModel
    {
        let title: String
        let titleColor: UIColor
        let titleFont: UIFont
    }
    
    weak open var dataSource: SelectionViewDataSource?
    weak open var delegate: SelectionViewDelegate?
    
    private let stackView: UIStackView = .init()
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    func layoutUI()
    {
        guard let ds = dataSource else { return }
        
        for index: Int in 0..<ds.numberOfButtons(in: self)
        {
            let button: UIButton = .init()
            let buttonModel = ds.selectionView(self, buttonAt: index)
            button.setTitle(buttonModel.title, for: .normal)
            button.setTitleColor(buttonModel.titleColor, for: .normal)
            button.titleLabel?.font = buttonModel.titleFont
            stackView.addArrangedSubview(button)
        }
        
        stackView.axis = .horizontal
    }
}
