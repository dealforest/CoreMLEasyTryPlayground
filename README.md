# CoreML Easy Try Playground
[![Swift](https://img.shields.io/badge/Swift-5.1-orange.svg)](https://developer.apple.com/swift/)
[![Swift Playgrounds](https://img.shields.io/badge/Swift%20Playgrounds-3.1-orange.svg)](https://itunes.apple.com/jp/app/swift-playgrounds/id908519492)
[![License](https://img.shields.io/github/license/kkk669/coreml-playground.svg)](LICENSE)

This repository is a collection of Playgrounds that you can easily try when working with CoreML.

📝I recommend that you set the build settings to manual, because it's less likely to crash.

## predictNotUseAutoGenerateModel.playground
All the samples don't use the model automatically generated from mlmodel.

### Vision
This feature uses Vision.framework to execute prediction on a model.

<img src="https://github.com/dealforest/CoreMLEasyTryPlayground/raw/master/images/predict_vision.png" width="400">

### CoreML_CVPixelBuffer
This feature uses CoreML.framework to execute prediction by `CVPixelBuffer` on a model.

### CoreML_MLMultiArray
This feature uses CoreML.framework to execute prediction by `MLMultiArray` on a model.  
⚠️ I don't recommend using `MLMultiArray` directly.  
Please check [this link](https://machinethink.net/blog/coreml-image-mlmultiarray/) if you are interested.

### drawingImageWithVision

This feature uses Vision.framework to execute prediction on a model using handwritten characters.

<img src="https://github.com/dealforest/CoreMLEasyTryPlayground/raw/master/images/predict_drawing_image_with_vision.png" width="400">

⚠️ To try this feature, you enable Live View.  
<img src="https://github.com/dealforest/CoreMLEasyTryPlayground/raw/master/images/enable_live_view.png" width="200">

## utils.playground
This feature saves handwriting as a png image.

<img src="https://github.com/dealforest/CoreMLEasyTryPlayground/raw/master/images/utils_draw_save_image.png" width="400">

⚠️ To try this feature, you enable Live View.  
<img src="https://github.com/dealforest/CoreMLEasyTryPlayground/raw/master/images/enable_live_view.png" width="200">

## Models
The mnist model was created with reference to [this page](https://github.com/keras-team/keras/blob/master/examples/mnist_cnn.py).

### Mnist.mlmodel
| framework | input type |
|:---------:|:-----------:|
| Vision | - |
| CoreML | `MLMultiArray` |

<img src="https://github.com/dealforest/CoreMLEasyTryPlayground/raw/master/images/mnist_description.png" width="250">

### MnistImageInput.mlmodel

| framework | input type |
|:---------:|:-----------:|
| Vision | `UIImage` |
| CoreML | `CVPixelBuffer` |

<img src="https://github.com/dealforest/CoreMLEasyTryPlayground/raw/master/images/mnist_with_interface_description.png" width="250">

