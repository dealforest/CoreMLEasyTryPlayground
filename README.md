# CoreML Easy Try Playground
[![Swift](https://img.shields.io/badge/Swift-5.1-orange.svg)](https://developer.apple.com/swift/)
[![Swift Playgrounds](https://img.shields.io/badge/Swift%20Playgrounds-3.1-orange.svg)](https://itunes.apple.com/jp/app/swift-playgrounds/id908519492)
[![License](https://img.shields.io/github/license/kkk669/coreml-playground.svg)](LICENSE)

This repository is a collection of Playgrounds that you can easily try when working with CoreML.


## predict.playground

### Vision
This feature uses Vision.framework to execute prediction on a model.

![predict vision](https://github.com/dealforest/CoreMLEasyTryPlayground/raw/master/images/predict_vision.png)

### CoreML
This feature uses CoreML.framework to execute prediction on a model.

### drawingImageWithVision

This feature uses Vision.framework to execute prediction on a model using handwritten characters.

![predict drawing image with vision](https://github.com/dealforest/CoreMLEasyTryPlayground/raw/master/images/predict_drawing_image_with_vision.png)

⚠️ To try this feature, you enable Live View.  
![enable live view](https://github.com/dealforest/CoreMLEasyTryPlayground/raw/master/images/enable_live_view.png)

## utils.playground
This feature saves handwriting as a png image.

![utils draw save image](https://github.com/dealforest/CoreMLEasyTryPlayground/raw/master/images/utils_draw_save_image.png)

⚠️ To try this feature, you enable Live View.  
![enable live view](https://github.com/dealforest/CoreMLEasyTryPlayground/raw/master/images/enable_live_view.png)

## Models
The mnist model was created with reference to [this page](https://github.com/keras-team/keras/blob/master/examples/mnist_cnn.py).

### Mnist.mlmodel
input is `MultiArray`.

![enable live view](https://github.com/dealforest/CoreMLEasyTryPlayground/raw/master/images/mnist_description.png)

### MnistWithInterface.mlmodel
input is `UIImage` or `CVPixelBuffer`.

![enable live view](https://github.com/dealforest/CoreMLEasyTryPlayground/raw/master/images/mnist_with_interface_description.png)