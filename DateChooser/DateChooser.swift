/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
 |  ‾        ‾        ‾
 */

import UIKit

@IBDesignable open class DateChooser: UIView {
    
    // MARK: - IB Inspectable properties
    
    @IBInspectable open var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable open var titleColor: UIColor = .black {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable open var neutralColor: UIColor = .darkGray {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable open var destructiveColor: UIColor = .red {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable open var innerBorderColor: UIColor = .lightGray {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable open var titleFont: UIFont = .systemFont(ofSize: 17) {
        didSet {
            title.font = titleFont
        }
    }
    
    @IBInspectable open var buttonFont: UIFont = .systemFont(ofSize: 16) {
        didSet {
            removeDateButton.titleLabel?.font = buttonFont
            setToCurrentButton.titleLabel?.font = buttonFont
            saveButton.titleLabel?.font = buttonFont
        }
    }
    
    @IBInspectable open var capabilities: Int = DateChooserCapabilities.standard.rawValue {
        didSet {
            updateCapabilities()
        }
    }
    
    @IBInspectable open var minuteInterval: Int = 5 {
        didSet {
            datePicker.minuteInterval = minuteInterval
        }
    }
    
    @IBInspectable open var startingDate: Date? {
        didSet {
            datePicker.date = startingDate ?? Date()
            updateDate()
        }
    }
    
    
    // MARK: - Public properties
    
    open var chosenDate: Date?
    
    
    // MARK: - Computed properties
    
    var computedCapabilities: DateChooserCapabilities {
        return DateChooserCapabilities(rawValue: capabilities)
    }
    
    
    // MARK: - Internal properties
    
    let title = UILabel()
    let segmentedControl = UISegmentedControl(items: [NSLocalizedString("Date", comment: "Title for date in segmented control"), NSLocalizedString("Time", comment: "Title for time in segmented control")])
    let datePicker = UIDatePicker()
    let removeDateBorder = UIView()
    let removeDateButton = UIButton(type: .system)
    let currentBorder = UIView()
    let setToCurrentButton = UIButton(type: .system)
    let saveBorder = UIView()
    let saveButton = UIButton(type: .system)
    let stackView = UIStackView()
    
    
    // MARK: - Private properties
    
    fileprivate lazy var dateFormatter = DateFormatter()
    
    
    // MARK: - Constants
    
    static fileprivate let innerMargin: CGFloat = 8.0
    static fileprivate let innerRuleHeight: CGFloat = 1.0
    static fileprivate let buttonHeight: CGFloat = 44.0
    
    
    // MARK: - Overrides
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    open override func tintColorDidChange() {
        updateColors()
    }
    
    
    // MARK: - Internal functions
    
    func updateDatePicker() {
        let temp = 4
    }
    
    func dateChanged() {
        let temp = 3
        updateDate()
    }
    
    func removeDate() {
        let temp = 4
    }
    
    func setDateToCurrent() {
        let temp = 2
    }
    
    func saveChanges() {
        let temp = 3
    }
    
}


// MARK: - Private functions

private extension DateChooser {
    
    func setupViews() {
        addSubview(stackView)
        constrainFullWidth(stackView, top: DateChooser.innerMargin)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        let titleContainer = UIView()
        titleContainer.addSubview(title)
        constrainFullWidth(title, leading: DateChooser.innerMargin, trailing: DateChooser.innerMargin)
        stackView.addArrangedSubview(titleContainer)
        title.font = titleFont
        
        let segmentedContainer = UIView()
        segmentedContainer.addSubview(segmentedControl)
        constrainFullWidth(segmentedControl, leading: DateChooser.innerMargin * 2, top: DateChooser.innerMargin, trailing: DateChooser.innerMargin * 2, bottom: DateChooser.innerMargin)
        stackView.addArrangedSubview(segmentedContainer)
        segmentedControl.addTarget(self, action: #selector(updateDatePicker), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 1
        
        stackView.addArrangedSubview(datePicker)
        updateDatePicker()
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        stackView.addArrangedSubview(removeDateBorder)
        removeDateBorder.heightAnchor.constraint(equalToConstant: DateChooser.innerRuleHeight).isActive = true
        stackView.addArrangedSubview(removeDateButton)
        removeDateButton.addTarget(self, action: #selector(removeDate), for: .touchUpInside)
        removeDateButton.heightAnchor.constraint(equalToConstant: DateChooser.buttonHeight).isActive = true
        removeDateButton.setTitle(NSLocalizedString("Remove date", comment: "Button title to remove date"), for: .normal)

        stackView.addArrangedSubview(currentBorder)
        currentBorder.heightAnchor.constraint(equalToConstant: DateChooser.innerRuleHeight).isActive = true
        stackView.addArrangedSubview(setToCurrentButton)
        setToCurrentButton.addTarget(self, action: #selector(setDateToCurrent), for: .touchUpInside)
        setToCurrentButton.heightAnchor.constraint(equalToConstant: DateChooser.buttonHeight).isActive = true

        stackView.addArrangedSubview(saveBorder)
        saveBorder.heightAnchor.constraint(equalToConstant: DateChooser.innerRuleHeight).isActive = true
        stackView.addArrangedSubview(saveButton)
        saveButton.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
        saveButton.heightAnchor.constraint(equalToConstant: DateChooser.buttonHeight).isActive = true
        saveButton.setTitle(NSLocalizedString("Save", comment: "Save button title"), for: .normal)

        updateColors()
        updateCapabilities()
        updateDate()
    }
    
    func updateColors() {
        title.textColor = titleColor
        segmentedControl.tintColor = tintColor
        removeDateButton.tintColor = destructiveColor
        setToCurrentButton.tintColor = neutralColor
        saveButton.tintColor = tintColor
        removeDateBorder.backgroundColor = innerBorderColor
        currentBorder.backgroundColor = innerBorderColor
        saveBorder.backgroundColor = innerBorderColor
    }
    
    func updateCapabilities() {
        let includeRemoveData = computedCapabilities.contains(.removeDate)
        removeDateBorder.isHidden = !includeRemoveData
        removeDateButton.isHidden = !includeRemoveData
        let includeCurrent = computedCapabilities.contains(.setToCurrent)
        currentBorder.isHidden = !includeCurrent
        setToCurrentButton.isHidden = !includeCurrent
        let dateAndTimeSeparate = computedCapabilities.contains(.dateAndTimeSeparate)
        segmentedControl.isHidden = !dateAndTimeSeparate
        let currentButtonTitle: String
        if dateAndTimeSeparate {
            datePicker.datePickerMode = .time
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .full
            currentButtonTitle = NSLocalizedString("Set to current date/time", comment: "Button title to set date to current date and time")
        } else if computedCapabilities.contains(.timeOnly) {
            datePicker.datePickerMode = .time
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .none
            currentButtonTitle = NSLocalizedString("Set to current time", comment: "Button title to set date to current time")
        } else if computedCapabilities.contains(.dateAndTimeCombined) {
            datePicker.datePickerMode = .dateAndTime
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .full
            currentButtonTitle = NSLocalizedString("Set to current date/time", comment: "Button title to set date to current date and time")
        } else {
            datePicker.datePickerMode = .date
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .full
            currentButtonTitle = NSLocalizedString("Set to current date", comment: "Button title to set date to current date")
        }
        setToCurrentButton.setTitle(currentButtonTitle, for: .normal)
    }
    
    func updateDate() {
        title.text = dateFormatter.string(from: datePicker.date)
    }
    
    func constrainFullWidth(_ view: UIView, leading: CGFloat = 0, top: CGFloat = 0, trailing: CGFloat = 0, bottom: CGFloat = 0) {
        guard let superview = view.superview else { fatalError("\(view) has no superview") }
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading).isActive = true
        view.topAnchor.constraint(equalTo: superview.topAnchor, constant: top).isActive = true
        view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -trailing).isActive = true
        view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -bottom).isActive = true
    }
    
}