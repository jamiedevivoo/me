import UIKit
import SnapKit
import Firebase

final class HeadlineLoggingMoodViewController: ViewController {
    
    // Delegates
    weak var moodLogDataCollectionDelegate: MoodLoggingDelegate?
    weak var screenSliderDelegate: ScreenSliderViewController?
    
    // Views
    lazy var headerLabel = HeaderLabel.init("Log Title", .largeScreen)
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let btnImage = UIImage(named: "up-circle")?.withRenderingMode(.alwaysTemplate)
        btnImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(btnImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.isUserInteractionEnabled = true
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonActive), for: .touchDown)
        button.addTarget(self, action: #selector(buttonActive), for: .touchDragEnter)
        button.addTarget(self, action: #selector(buttonCancelled), for: .touchDragExit)
        button.addTarget(self, action: #selector(buttonCancelled), for: .touchCancel)
        button.alpha = 0.5
        button.layer.shadowRadius = 3.0
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        return button
    }()
    
    lazy var headLineTextFieldWithLabel: TextFieldWithLabel = {
        let textFieldWithLabel = TextFieldWithLabel()
        textFieldWithLabel.textField.font = UIFont.systemFont(ofSize: 36, weight: .light)
        textFieldWithLabel.textField.adjustsFontSizeToFitWidth = true
        textFieldWithLabel.textField.placeholder = "I'm feeling..."
        textFieldWithLabel.labelTitle = "Describe how your feeling"
        return textFieldWithLabel
    }()
    
    lazy var tapToTogglekeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.toggleFirstResponder(_:)))
}

// MARK: - Override Methods
extension HeadlineLoggingMoodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        view.backgroundColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        headLineTextFieldWithLabel.textField.placeholder = "I'm Feeling \(moodLogDataCollectionDelegate?.emotion?.adj ?? "")..."
        screenSliderDelegate?.backwardNavigationEnabled = false
        setupKeyboard()
    }
    
}

// MARK: - Class Methods
extension HeadlineLoggingMoodViewController {
    
    @objc func validateHeadline() -> String? {
        guard
            let headline: String = self.headLineTextFieldWithLabel.textField.text?.trim(),
            self.headLineTextFieldWithLabel.textField.text!.trim().count > 1
        else { return nil }
        moodLogDataCollectionDelegate?.headline = headline
        headLineTextFieldWithLabel.resetHint()
        self.headLineTextFieldWithLabel.textField.text = headline
        return headline
    }
}

// MARK: - TextField Delegate Methods
extension HeadlineLoggingMoodViewController: UITextFieldDelegate {
    func setupKeyboard() {
        headLineTextFieldWithLabel.textField.delegate = self
        self.headLineTextFieldWithLabel.textField.addTarget(self, action: #selector(validateHeadline), for: .editingChanged)
        view.addGestureRecognizer(tapToTogglekeyboardGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let headline = validateHeadline() {
            headLineTextFieldWithLabel.textField.resignFirstResponder()
            screenSliderDelegate?.nextScreen()
            moodLogDataCollectionDelegate?.headline = headline
            return true
        } else {
            moodLogDataCollectionDelegate?.headline = nil
            headLineTextFieldWithLabel.textField.shake()
            headLineTextFieldWithLabel.resetHint(withText: "Your title needs to be at least 2 characters")
        }
        return false
    }
    
    @objc func toggleFirstResponder(_ sender: UITapGestureRecognizer? = nil) {
        if headLineTextFieldWithLabel.textField.isFirstResponder {
            headLineTextFieldWithLabel.textField.resignFirstResponder()
        } else {
            headLineTextFieldWithLabel.textField.becomeFirstResponder()
        }
    }
}

// MARK: - Buttons
extension HeadlineLoggingMoodViewController {
    
    @objc func goBack() {
        screenSliderDelegate?.backwardNavigationEnabled = true
        self.screenSliderDelegate?.previousScreen()
    }
    
    @objc func buttonActive(sender: UIButton) {
        focusButton(sender)
    }
    
    @objc func buttonCancelled(sender: UIButton) {
        unFocusButton(sender)
    }
    
    private func focusButton(_ button: UIButton) {
        let duration = 0.6
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
        button.layer.shadowRadius += 1.0
        button.layer.shadowOpacity -= 0.2
        button.layer.shadowOffset = CGSize(width: button.layer.shadowOffset.width + 0.5, height: button.layer.shadowOffset.height + 4.0)
        CATransaction.commit()
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: [.curveEaseInOut],
                       animations: {
                        button.alpha += 0.2
                        button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        })
    }
    
    private func unFocusButton(_ button: UIButton) {
        let duration = 0.4
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
        button.layer.shadowRadius -= 1.0
        button.layer.shadowOpacity += 0.2
        button.layer.shadowOffset = CGSize(width: button.layer.shadowOffset.width - 0.5, height: button.layer.shadowOffset.height - 4.0)
        CATransaction.commit()
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: [.curveEaseInOut],
                       animations: {
                        button.alpha -= 0.2
                        button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
}

// MARK: - View Building
extension HeadlineLoggingMoodViewController: ViewBuilding {
    
    func setupChildViews() {
        self.view.addSubview(headerLabel)
        self.view.addSubview(headLineTextFieldWithLabel)
        view.addSubview(backButton)
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(15)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        headerLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.greaterThanOrEqualTo(50)
        }
        headLineTextFieldWithLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(25)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.height.greaterThanOrEqualTo(60)
        }
    }
}
