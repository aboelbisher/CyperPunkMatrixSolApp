//
//  ViewController.swift
//  CyperPunkMatrix
//
//  Created by Muhammad Abed on 06/02/2021.
//  Copyright © 2021 Trax. All rights reserved.
//

import UIKit
import AVFoundation
import TOCropViewController


class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TOCropViewControllerDelegate {
    
  enum Mode {
      case initial, tookMatrix


      mutating func next() {

          switch self {
          case .initial:
              self = .tookMatrix

          case .tookMatrix:
              self = .initial
          }
      }
  }

  @IBOutlet weak var takeImgBtn: UIButton!
  @IBOutlet weak var widthTxtField: UITextField!

  private var mode : Mode = .initial {
      didSet {
          switch self.mode {
          case .initial:
            takeImgBtn.setTitle("Take matrix image", for: .normal)
            widthTxtField.placeholder = "Matrix width"
            widthTxtField.text = nil


          case .tookMatrix:
            takeImgBtn.setTitle("Take sequence image", for: .normal)
            widthTxtField.placeholder = "Buffer size"
            widthTxtField.text = nil

          }
      }
  }

  let imgPicker = UIImagePickerController()

  private var matrix : [[String]]?
  private var sequences : [[String]]?

  override func viewDidLoad() {
      super.viewDidLoad()

    self.view.backgroundColor = .gray
    takeImgBtn.setTitle("Take matrix image", for: .normal)
    takeImgBtn.addTarget(self, action: #selector(self.takeImageBtnClicked(sender:)), for: .touchUpInside)
    takeImgBtn.setTitleColor(.black, for: .normal)


  }

  @objc func takeImageBtnClicked(sender : UIButton) {

     imgPicker.delegate = self
     imgPicker.sourceType = .camera
     imgPicker.allowsEditing = false
     imgPicker.showsCameraControls = true
     self.present(imgPicker, animated: true, completion: nil)
  }


  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

      imgPicker.dismiss(animated: true, completion: nil)
      let image = (info[UIImagePickerController.InfoKey.editedImage] as? UIImage) ?? ( info[UIImagePickerController.InfoKey.originalImage] as? UIImage)

      if let _image = image {
        let cropViewController = TOCropViewController(image: _image)
        cropViewController.delegate = self
        present(cropViewController, animated: true, completion: nil)

      } else {

          self.showError(txt : "please make sure to take a picture of only the relevant text (without any other texts; the app isn't that smart ! )")
      }
  }


  func processSequence(_image : UIImage) {

      let processor = ImageProcessor(image: _image)

      processor.getText { [weak self] (res) in

          guard  let res = res else {
              self?.showError(txt : "please make sure to take a picture of only the relevant text (without any other texts; the app isn't that smart ! )")
              return
          }
          self?.sequences = TextToMatrix.getSequence(fromText: res)
          guard let sequences = self?.sequences, let matrix = self?.matrix else {
              return
          }


        if let _bufferSize = Int(self?.widthTxtField.text ?? "") {
          let txt = res.reduce("") {$0 + $1 + "\n"}
          let alert = UIAlertController(title: "Confirm sequences", message: txt, preferredStyle: .alert)
          let ok = UIAlertAction(title: "Confirm", style: .default) { (action) in
              alert.dismiss(animated: true, completion: nil)

            let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
            activityIndicator.startAnimating()
            activityIndicator.center = self?.view.center ?? CGPoint.zero
            self?.view.addSubview(activityIndicator)

            DispatchQueue.global(qos: .userInitiated).async {
              let solve = CyperMatrixSol(matrix: matrix, sequences: sequences, bufferSize: _bufferSize)
              let (seq, indexes) = solve.solve()

              let alert = UIAlertController(title: "Solution !",
                                            message: "sequence is: \n \(seq) \n indexes are:\n \(indexes)",
                                            preferredStyle: .alert)
              let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                  alert.dismiss(animated: true, completion: nil)
                  self?.mode = .initial
              }
              alert.addAction(ok)
              DispatchQueue.main.async {
                activityIndicator.removeFromSuperview()
                  self?.present(alert, animated: true, completion: nil)
              }

            }
          }
          let retry = UIAlertAction(title: "Retry", style: .default) { (action) in
              self?.mode = .tookMatrix
              alert.dismiss(animated: true, completion: nil)
          }
          alert.addAction(ok)
          alert.addAction(retry)
          DispatchQueue.main.async {
              self?.present(alert, animated: true, completion: nil)
          }
        } else {
          let alert = UIAlertController(title: "Error", message: "please provide the buffer size", preferredStyle: .alert)
          let ok = UIAlertAction(title: "OK", style: .default) { (action) in
              alert.dismiss(animated: true, completion: nil)
              self?.mode = .tookMatrix
          }
          alert.addAction(ok)
          DispatchQueue.main.async {
              self?.present(alert, animated: true, completion: nil)
          }
        }

      }

  }


  func processMatrixImage(_image : UIImage) {

      let processor = ImageProcessor(image: _image)
      processor.getText { [weak self] (res) in
          guard let res = res else {
              self?.showError(txt : "please make sure to take a picture of only the relevant text (without any other texts; the app isn't that smart ! )")
              return
          }
          guard let self = self else {
              return
          }
          if let matrixWidth = Int(self.widthTxtField.text ?? "") {

              self.matrix = TextToMatrix.getMatrix(fromText: res, width: matrixWidth)

              var txt = ""
              for line in self.matrix! {
                  txt += (line.reduce("") {$0 + " " + $1 } + "\n")

              }
              let alert = UIAlertController(title: "Confirm matrix", message: txt, preferredStyle: .alert)
              let ok = UIAlertAction(title: "Confirm", style: .default) { (action) in
                  alert.dismiss(animated: true, completion: nil)
              }
              let retry = UIAlertAction(title: "Retry", style: .default) { (action) in

                  self.mode = .initial
                  alert.dismiss(animated: true, completion: nil)
              }
              alert.addAction(ok)
              alert.addAction(retry)
              DispatchQueue.main.async {
                  self.present(alert, animated: true, completion: nil)
              }
          } else {

            let alert = UIAlertController(title: "Error", message: "please provide the Matrid width", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
                self.mode = .initial
            }
            alert.addAction(ok)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }

          }
      }
  }


  func showError(txt : String) {
      let alert = UIAlertController(title: "Error",
                                    message: txt,
                                    preferredStyle: .alert)

      let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      alert.addAction(ok)
      self.mode = .initial
      DispatchQueue.main.async {
          self.present(alert, animated: true, completion: nil)
      }

  }


  func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {

    DispatchQueue.main.async {

      cropViewController.dismiss(animated: true, completion: nil)
//
      switch self.mode {
      case .initial: // matrix
        self.processMatrixImage(_image: image)
          self.mode.next()

      case .tookMatrix: //squence
        self.processSequence(_image: image)
          self.mode.next()
      }
    }


  }
}


