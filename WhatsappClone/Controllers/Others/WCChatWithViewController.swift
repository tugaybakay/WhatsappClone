//
//  WCChatWithViewController.swift
//  WhatsappClone
//
//  Created by MacOS on 4.04.2024.
//

import UIKit
import MessageKit
import FirebaseAuth
import Photos

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

class WCChatWithViewController: MessagesViewController {

//    let chatView = WCChatWithView()
    var user: WCContact!
    var roomid: String? {
        didSet {
            WCFirabaseCRUD.shared.getMessages(roomid: roomid ?? "") { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let messagesFromFirebase):
                    strongSelf.messages.removeAll()
                    for message in messagesFromFirebase {
                        if message.reciever == strongSelf.selfSender.senderId {
                            let m = Message(sender: Sender(senderId: message.sender, displayName: ""), messageId: "", sentDate: message.date.dateValue(), kind: .text(message.text))
                            strongSelf.messages.append(m)
                        }else {
                            let m = Message(sender: strongSelf.selfSender, messageId: "", sentDate: message.date.dateValue(), kind: .text(message.text))
                            strongSelf.messages.append(m)
                        }
                    }
                    strongSelf.messagesCollectionView.reloadData()
                    strongSelf.messagesCollectionView.scrollToBottom(animated: true)
                case .failure:
                    break
                }
            }
        }
        
    }
    
    private let selfSender = Sender(senderId: Auth.auth().currentUser?.phoneNumber ?? "", displayName: Auth.auth().currentUser?.phoneNumber ?? "")
    private var messages: [Message] = []
    
    init(user: WCContact) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    init(user: WCContact, roomid: String) {
        self.user = user
        self.roomid = roomid
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let button   = UIButton(type: UIButton.ButtonType.system) as UIButton
        messageInputBar.inputTextView.text = "adjlaldkjaslkjdlkajsldkjalkdjalsjdlsajdlsajdljasldjasldjlasjdljasldjasljdlasjdljadljaslkdjasjldadasdlasj"
        messageInputBar.inputTextView.text.removeAll()
//        button.titleLabel?.font = messageInputBar.inputTextView.font
        button.frame = CGRectMake(0, 0, 0, 0)
//        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 5, bottom: 0, right: 0)
        button.setImage(UIImage(systemName: "photo"), for: .normal)
//        button.setTitle("ada", for: .normal)
        button.tintColor = UIColor.systemBlue
//         button.backgroundColor = UIColor.yellowColor()


        button.translatesAutoresizingMaskIntoConstraints = false
        messageInputBar.inputTextView.addSubview(button)
        NSLayoutConstraint.activate([
            button.rightAnchor.constraint(equalTo: messageInputBar.inputTextView.textInputView.rightAnchor,constant: -5),
            button.centerYAnchor.constraint(equalTo: messageInputBar.inputTextView.textInputView.centerYAnchor)
        ])
                messageInputBar.inputTextView.translatesAutoresizingMaskIntoConstraints = false
        let buttonFrame = CGRect(x: 275, y: 0, width: button.frame.size.width + 10, height: (messageInputBar.inputTextView.font?.lineHeight)! as CGFloat * 20)
        let exclusivePath = UIBezierPath(rect: buttonFrame)
        messageInputBar.inputTextView.textContainer.exclusionPaths = [exclusivePath]
        button.sizeToFit()
        button.addTarget(self, action: #selector(didTapPhotoButton), for: .touchUpInside)

        
//        messageInputBar.inputTextView.textContainer.exclusionPaths = -90
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(didTapBackButton))
        
        let phoneBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "phone"), style: .plain, target: nil, action: nil)
        let cameraBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "video"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItems = [cameraBarButtonItem,phoneBarButtonItem]
        navigationItem.leftBarButtonItem = backButton
        
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        
//        WCFirabaseCRUD.shared.checkRoom(receiver: user.phoneNumber) { [weak self] roomid in
//            self?.roomid = roomid
//        }
        
        if roomid == nil {
            WCFirabaseCRUD.shared.checkRoom(receiver: user.phoneNumber) { [weak self] roomid in
                self?.roomid = roomid
            }
        }else {
            WCFirabaseCRUD.shared.getMessages(roomid: roomid ?? "") { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let messagesFromFirebase):
                    strongSelf.messages.removeAll()
                    for message in messagesFromFirebase {
                        if message.reciever == strongSelf.selfSender.senderId {
                            if message.text != ""{
                                let m = Message(sender: Sender(senderId: message.sender, displayName: ""), messageId: "", sentDate: message.date.dateValue(), kind: .text(message.text))
                                strongSelf.messages.append(m)
                            }else {
                                
//                                UIImageWriteToSavedPhotosAlbum(message.image!, nil, nil, nil)
                                let media = ImageMediaItem(url: nil, placeholderImage: message.image!, size: message.image!.size)
                                let m = Message(sender: Sender(senderId: message.sender, displayName: ""), messageId: "", sentDate: message.date.dateValue(), kind: .photo(media))
                                strongSelf.messages.append(m)
                            }
                            
                        }else {
                            if message.text != "" {
                                let m = Message(sender: strongSelf.selfSender, messageId: "", sentDate: message.date.dateValue(), kind: .text(message.text))
                                strongSelf.messages.append(m)
                            }else {
//                                UIImageWriteToSavedPhotosAlbum(message.image!, nil, nil, nil)
                                let media = ImageMediaItem(url: nil, placeholderImage: message.image!, size: message.image!.size)
                                let m = Message(sender: strongSelf.selfSender, messageId: "", sentDate: message.date.dateValue(), kind: .photo(media))
                                strongSelf.messages.append(m)
                                
                            }
                            
                        }
                    }
                    strongSelf.messagesCollectionView.reloadData()
                    strongSelf.messagesCollectionView.scrollToBottom(animated: true)
                case .failure:
                    break
                }
            }
        }
        
        
        
        messageInputBar.sendButton.setImage(UIImage(systemName: "paperplane"), for: .normal)
        messageInputBar.sendButton.title = ""
        let userInterfaceStyle = traitCollection.userInterfaceStyle
        if userInterfaceStyle == .dark {
            messagesCollectionView.backgroundView = UIImageView(image: UIImage(named: "wallpaper2"))
        }else {
            messagesCollectionView.backgroundView = UIImageView(image: UIImage(named: "wallpaper1"))
        }
        
//        view.addSubview(chatView)
        view.backgroundColor = .systemBackground
//        setUpConstraints()
        
        let titleView =  ImageTextNavBarView(frame: navigationController?.navigationBar.frame ?? .zero)
        
        if let data = Data(base64Encoded: user.image ?? "", options: .ignoreUnknownCharacters),let image = UIImage(data: data) {
            titleView.setImage(image, text: user.name)
        }else{
            titleView.setImage(UIImage(systemName: "circle.fill")!.withTintColor(.black), text: user.name)
        }
//        titleView.sizeToFit()
        navigationItem.titleView = titleView
        
        messageInputBar.inputTextView.layer.borderWidth = 0.3
        messageInputBar.inputTextView.layer.cornerRadius = 15
        messageInputBar.inputTextView.layer.borderColor = UIColor.lightGray.cgColor
        

        messageInputBar.sendButton.addTarget(self, action: #selector(sendButtonDidTap), for: .touchUpInside)
    }
    
    
//    private func setUpConstraints() {
//        NSLayoutConstraint.activate([
//            chatView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            chatView.leftAnchor.constraint(equalTo: view.leftAnchor),
//            chatView.rightAnchor.constraint(equalTo: view.rightAnchor),
//            chatView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
    
    
    @objc private func sendButtonDidTap() {
        guard let roomid = roomid else { return }
        let message = WCMessage(roomid: roomid,text: messageInputBar.inputTextView.text, reciever: user.phoneNumber, date: .init(date: .now), sender: Auth.auth().currentUser?.phoneNumber ?? "",image: nil)
        WCFirabaseCRUD.shared.sendMessage(message)
        messageInputBar.inputTextView.text = ""

    }

    @objc func didTapBackButton() {
        self.dismiss(animated: true)
    }

}

extension WCChatWithViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> MessageKit.SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    
    @objc func didTapPhotoButton() {
        let imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
}

extension WCChatWithViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] {
                        guard let roomid = roomid else { return }
            let message = WCMessage(roomid: roomid,text: "", reciever: user.phoneNumber, date: .init(date: .now), sender: Auth.auth().currentUser?.phoneNumber ?? "", image: pickedImage as? UIImage)
            WCFirabaseCRUD.shared.sendMessage(message)
            
            picker.dismiss(animated: true)
            messagesCollectionView.scrollToBottom(animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

class ImageTextNavBarView: UIView {

  let imageView: UIImageView
  let titleLabel: UILabel

  override init(frame: CGRect) {
    imageView = UIImageView(frame: .zero)
    titleLabel = UILabel(frame: .zero)
      
      
    super.init(frame: frame)
    backgroundColor = .red
    // Configure image and label properties here (e.g., size, content mode)
    imageView.contentMode = .scaleAspectFit
    titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
      

    // Add image and label views as subviews
    addSubview(imageView)
    addSubview(titleLabel)
      
    // Layout the subviews using constraints or auto layout
    imageView.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
      
      imageView.layer.cornerRadius = 40 / 2
      imageView.contentMode = .scaleAspectFill
      imageView.clipsToBounds = true
      
      let margin = UIScreen.main.bounds.width / -2.44
      
    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin ),
      imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
      imageView.heightAnchor.constraint(equalToConstant: 40),
      imageView.widthAnchor.constraint(equalToConstant: 40),

      titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
      titleLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
//      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
    ])
      
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // Set image and text programmatically
  func setImage(_ image: UIImage, text: String) {
    imageView.image = image
    titleLabel.text = text
  }
    
}


class ImageMediaItem: MediaItem {
    var url: URL? // Eğer varsa, resmin URL'si
    var image: UIImage? // Resim
    var placeholderImage: UIImage // Yer tutucu resim
    var size: CGSize // Resmin boyutu

    init(url: URL?, placeholderImage: UIImage, size: CGSize) {
        self.image = nil
        self.url = url
        self.placeholderImage = placeholderImage
        self.size = size
    }
}
