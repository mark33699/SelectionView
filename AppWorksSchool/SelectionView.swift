//
//  SelectionView.swift
//  AppWorksSchool
//
//  Created by iOS_Mark on 2020/2/10.
//  Copyright © 2020 IPK. All rights reserved.
//

import UIKit

//MARK:- SelectionViewDataSource
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
        return .init(title: "default \(index)", titleColor: .white, titleFont: .systemFont(ofSize: 18))
    }
}

//MARK:- SelectionViewDelegate
@objc
protocol SelectionViewDelegate: AnyObject
{
    @objc optional func selectionView(_ selectionView: SelectionView, didSelectAt index: Int)
    @objc optional func selectionView(_ selectionView: SelectionView, shouldSelectAt index: Int) -> Bool
}

//MARK:- SelectionView
class SelectionView: UIView
{
    struct ButtonModel
    {
        let title: String
        let titleColor: UIColor
        let titleFont: UIFont
    }
    
    private let indicatorView: UIView = .init()
    private var indicatorWidthConstraint: NSLayoutConstraint = .init()
    private var indicatorLeftConstraint: NSLayoutConstraint = .init()
    private let stackView: UIStackView = .init()
    weak open var delegate: SelectionViewDelegate?
    weak open var dataSource: SelectionViewDataSource?
    {
        willSet
        {
            guard let ds = newValue else { return }
            
            for index: Int in 0..<ds.numberOfButtons(in: self)
            {
                let button: UIButton = .init()
                let buttonModel = ds.selectionView(self, buttonAt: index)
                button.setTitle(buttonModel.title, for: .normal)
                button.setTitleColor(buttonModel.titleColor, for: .normal)
                button.titleLabel?.font = buttonModel.titleFont
                button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
                button.tag = index
                stackView.addArrangedSubview(button)
            }
            indicatorView.backgroundColor = ds.indicatorColor(in: self)
            layoutSubviews() //確保不會layout後才得到dataSource
        }
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        guard let ds = dataSource else { return }
        indicatorWidthConstraint.constant = stackView.frame.width / CGFloat(ds.numberOfButtons(in: self))
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        layoutUI()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        layoutUI()
    }
    
    func layoutUI()
    {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        
        indicatorView.backgroundColor = .cyan
        addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        indicatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        indicatorLeftConstraint = indicatorView.leftAnchor.constraint(equalTo: leftAnchor)
        indicatorLeftConstraint.isActive = true
        indicatorWidthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: 0)
        indicatorWidthConstraint.isActive = true
    }
    
    @objc func didTapButton(btn: UIButton)
    {
        guard let dlg = delegate else { return }
        
        if dlg.selectionView?(self, shouldSelectAt: btn.tag) ?? true
        {
            dlg.selectionView?(self, didSelectAt: btn.tag)
            
            guard let ds = dataSource else { return }
            
            UIView.animate(withDuration: 2)
            {
                let width = self.stackView.frame.width / CGFloat(ds.numberOfButtons(in: self))
                self.indicatorLeftConstraint.constant = width * CGFloat(btn.tag)
                self.layoutIfNeeded() //動畫會動的關鍵
            }
        }
    }
}
