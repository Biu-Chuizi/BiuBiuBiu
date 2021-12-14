# import the necessary packages
from tensorflow.keras.losses import MeanSquaredError
from tensorflow.keras.losses import Reduction
from tensorflow import reduce_mean
class MSELoss():
	def __init__(self, scale):
		# accept the scalar by which the loss needs to be scaled
		self.scale = scale
	def __call__(self, real, pred):
		# initialize MeanSquaredError loss with no reduction
		MSE = MeanSquaredError(reduction=Reduction.NONE)
		# compute the loss
		loss = MSE(real, pred)
		# scale the loss
		loss = reduce_mean(loss) * (1. / self.scale)
		
		# return loss
		return loss
