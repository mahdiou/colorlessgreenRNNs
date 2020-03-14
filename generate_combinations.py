import itertools
import pandas as pd

params_dir = './data/model_params/'

model = ['LSTM']
nhid = [200, 650]
batch_size = [64, 128]
dropout = [0., .1, .2]
lr = [1., 5., 10., 20.]
epochs = [40]

names = ['model', 'nhid/emsize', 'batch_size', 'dropout', 'lr', 'epochs']
print("### generating params for LSTM ####")
params = [*itertools.product(
    model, nhid, batch_size, dropout, lr, epochs
)] + [*itertools.product(
    model, [200], [20], dropout, lr, epochs
)] + [*itertools.product(
    model, [650], batch_size, [0.4], lr, epochs
)]

df = pd.DataFrame(params, columns=names)
print(df.shape)
df.to_csv(params_dir + 'lstm_params.csv', index=False)


print("### generating params for sequential RNNs ####")

model = ['RNN_RELU', 'RNN_TANH']
nhid = [650]
batch_size = [64, 128]
dropout = [0., .1, .2]
lr = [.5, 1., 5., 10.]
epochs = [60]

params = [*itertools.product(
    model, nhid, batch_size, dropout, lr, epochs
)]

df = pd.DataFrame(params, columns=names)
print(df.shape)
df.to_csv(params_dir + 'sRNN_params.csv', index=False)


print("### generating params for 5-gram LSTMs ####")

model = ['LSTM']
nhid = [650]
batch_size = [256, 512, 1024]
dropout = [0., .1, .2]
lr = [1., 5., 10., 20.]
epochs = [60]

params = [*itertools.product(
    model, nhid, batch_size, dropout, lr, epochs
)]

df = pd.DataFrame(params, columns=names)
print(df.shape)
df.to_csv(params_dir + 'ngram_lstm_params.csv', index=False)
