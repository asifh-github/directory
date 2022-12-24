import numpy as np
import tensorflow as tf
import matplotlib as mpl
import IPython.display as display
import PIL.Image as pil_img
from tensorflow.keras.applications import InceptionV3, inception_v3   # pre-trained model
from tensorflow.keras.utils import get_file     # get file from url
from tensorflow.keras.preprocessing import image

# download an image and read it into np array
def download(url, max_dim=None):
    name = url.split('/')[-1]
    image_path = get_file(name, origin=url)
    img = pil_img.open(image_path)    # python image library, PIL
    if max_dim:
        img.thumbnail((max_dim, max_dim))
    return np.array(img)    # returns np array of image

# normalize image
def deprocess(img):
    img = 255 * (img + 1.0)/2.0     # preprocess image
    return tf.cast(img, tf.uint8)   # returns a casted version of image in ints

# display image
def show(img):
    display.display(pil_img.fromarray(np.array(img)))

# image url
url = 'https://storage.googleapis.com/download.tensorflow.org/example_images/YellowLabradorLooking_new.jpg'

# down-size image
og_img = download(url, max_dim=500)
show(og_img)
display.display(display.HTML('Image cc-by: <a "href=https://commons.wikimedia.org/wiki/File:Felis_catus-cat_on_snow.jpg">Von.grzanka</a>'))

# download a pre-trained model
base_model = InceptionV3(include_top=False, weights='imagenet')

# maximize activation function of layers
name = ['mixed3', 'mixed5']
layers = [base_model.get_layer(name).output for name in names]

# create feature extraction model
dream_model = tf.keras.Model(inputs=base_model.input, outputs=layers)

# calculate loss
def calc_loss(img, model):
    # pass image through model to retrieve activations
    img_batch = tf.expand_dims(img, axis=0)     # convert image into a batch of size 1 
    layer_activations = model(img_batch)
    if len(layer_activations) == 1:
        layer_activations = [layer_activations]

    losses = []
    for act in layer_activations:
        loss = tf.math.reduce_mean(act)
        losses.append(loss)

    return tf.math.reduce_sum(losses)

# Gradient Ascent
class DeepDream(tf.Module):
    def __init__(self, model):
        self.model = model

    @tf.function(
        input_signature=(
            tf.TensorSpec(shpae=[None, None, 3], dtype=tf.float32),
            tf.TensorSpec(shape=[], dtype=tf.int32),
            tf.TensorSpec(shape=[], dtype=tf.float32),)
    )
    def __call__(self, img, steps, step_size):
        print('Tracing')
        loss = tf.constant(0.0)
        for n in tf.range(steps):
            with tf.GradientTape() as tape:
                # needs gradient relative to 'img'
                # 'Gradienttape' only watches 'tf.Variable's bt default
                tape.watch(img)
                loss = calc_loss(img, self.model)

                # calculate gradient of loss w.r.t. pixels of input image
                gradients = tape.gradient(loss, img)
    
                # normalize gradients
                gradients /= tf.math.reduce_std(gradients) + 1e-8

                # "loss" is maximized s.t. input image increasingly "excites" the layers
                img = img + gradients * step_size   # can update image by directly adding the gradients b/c same shape
                img = tf.clip_by_value(img, -1, 1)

            return loss, img

# create DeepDream model
deepdream = DeepDream(dream_model)

# DeepDream model: Main Loop
def run_deep_dream_simple(img, steps=100, step_size=0.01):
    # convert from uint8 to range expected by the model
    img = inception_v3.preprocess_input(img)
    img = tf.convert_to_tensor(img)
    
    step_size = tf.convert_to_tensor(step_size)
    steps_remaining = steps
    steps = 0
    while steps_remaining:
        if steps_remaining > 100:
            run_steps = tf.constant(100)
        else:
            run_steps = tf.constant(steps_remaining)
        steps_remaining -= run_steps
        step += run_steps

        loss, img = deepdream(img, run_steps, tf.constant(step_size))

        display.clear_output(wait=True)
        show(deprocess(img))
        print("Step {}, loss {}".format(step, loss))

    result = deprocess(img)
    display.clear_output(wait=True)
    show(result)

# process image & view result
dream_img = run_deep_dream_simple(img=og_img, steps=100, step_size=0.01)
    




















