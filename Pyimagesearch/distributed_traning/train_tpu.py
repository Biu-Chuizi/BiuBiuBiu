# USAGE
# python train_tpu.py
# import tensorflow and fix the random seed for better reproducibility
import tensorflow as tf
tf.random.set_seed(42)
# import the necessary packages
from pyimagesearch import config
from pyimagesearch.data import get_data
from pyimagesearch.autoencoder import AutoEncoder
from pyimagesearch.loss import MSELoss
from tensorflow.distribute.cluster_resolver import TPUClusterResolver
from tensorflow.config import experimental_connect_to_cluster
from tensorflow.tpu.experimental import initialize_tpu_system
from tensorflow.distribute import TPUStrategy
from tensorflow.keras.preprocessing.image import array_to_img
import matplotlib.pyplot as plt
import os

# initialize the TPU and TPU strategy
tpu = TPUClusterResolver() 
experimental_connect_to_cluster(tpu)
initialize_tpu_system(tpu)
strategy = TPUStrategy(tpu)
# get the number of accelerators
numAcc = strategy.num_replicas_in_sync
print(f"[INFO] Number of accelerators: {numAcc}")
# get the training dataset
print("[INFO] loading the training and validation datasets...")
trainDs = get_data(dataName=config.DATA_NAME,
	split=config.TRAIN_FLAG, shuffleSize=config.SHUFFLE_SIZE,
	batchSize=config.TPU_BATCH_SIZE)
# get the validation dataset
valDs = get_data(dataName=config.DATA_NAME,
	split=config.VALIDATION_FLAG, batchSize=config.TPU_BATCH_SIZE)

    # train the model in the scope
with strategy.scope():
	# initialize the autoencoder model and compile it
	print("[INFO] initializing the model...")
	model = AutoEncoder()
	mseLoss = MSELoss(scale=1)
	model.compile(loss=mseLoss, optimizer=config.OPTIMIZER)
	# train the model
	print("[INFO] training the autoencoder...")
	model.fit(trainDs, epochs=config.EPOCHS,
		steps_per_epoch=config.TPU_STEPS_PER_EPOCH, 
		validation_data=valDs,
		validation_steps=config.TPU_VALIDATION_STEPS)

# grab a batch of data from the test set and run inference
print("[INFO] evaluating the model...")
(testIm, _) = next(iter(valDs))
predIm = model.predict(testIm)
# create subplots
fig, axes = plt.subplots(nrows=8, ncols=2, figsize=(10, 40))
# iterate over the subplots and fill with test and predicted images
print("[INFO] displaying the predicted images...")
for ax, real, pred in zip(axes, testIm[:8], predIm[:8]):
	# plot the input image
	ax[0].imshow(array_to_img(real), cmap="gray")
	ax[0].set_title("Input Image")
	# plot the predicted image
	ax[1].imshow(array_to_img(pred), cmap="gray")
	ax[1].set_title("Predicted Image")
# check if the output image directory exists, if does not, then create
# it
if not os.path.exists(config.BASE_IMG_PATH):
	os.makedirs(config.BASE_IMG_PATH)
# save the figure
print("[INFO] saving the predicted images...")
fig.savefig(config.TPU_IMG_PATH)