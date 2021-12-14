# import the necessary packages
from tensorflow.keras import Model
from tensorflow.keras import Sequential
from tensorflow.keras.layers import InputLayer
from tensorflow.keras.layers import Conv2D
from tensorflow.keras.layers import Conv2DTranspose
class AutoEncoder(Model):
	def __init__(self):
		super().__init__()
		# build the encoder
		self.encoder = Sequential([
			InputLayer((28, 28, 1)),
			Conv2D(16, (3, 3), activation='relu', padding='same', 
				strides=2),
			Conv2D(8, (3, 3), activation='relu', padding='same',
				strides=2)])
		
		# build the decoder
		self.decoder = Sequential([
			Conv2DTranspose(8, kernel_size=3, strides=2,
				activation='relu', padding='same'),
			Conv2DTranspose(16, kernel_size=3, strides=2,
				activation='relu', padding='same'),
			Conv2D(1, kernel_size=(3, 3), activation='sigmoid',
				padding='same')])
	
	def call(self, x):
		# pass the input through the encoder and output of the encoder
		# through the decoder
		encoded = self.encoder(x)
		decoded = self.decoder(encoded)
		
		# return the output from the decoder
		return decoded