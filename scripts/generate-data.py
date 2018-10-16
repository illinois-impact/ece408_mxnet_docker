#! /usr/bin/env python3

import urllib.request
import urllib.parse
from pathlib import Path
from builtins import FileExistsError
from reader import load_mnist, store_mnist
import numpy as np
np.set_printoptions(threshold=np.nan)
from skimage import io, transform
import sys
import os

FASHION_MNIST = {
    "http://fashion-mnist.s3-website.eu-central-1.amazonaws.com/train-images-idx3-ubyte.gz": "train-images-idx3-ubyte.gz",
    "http://fashion-mnist.s3-website.eu-central-1.amazonaws.com/train-labels-idx1-ubyte.gz": "train-labels-idx1-ubyte.gz",
    "http://fashion-mnist.s3-website.eu-central-1.amazonaws.com/t10k-images-idx3-ubyte.gz": "t10k-images-idx3-ubyte.gz",
    "http://fashion-mnist.s3-website.eu-central-1.amazonaws.com/t10k-labels-idx1-ubyte.gz": "t10k-labels-idx1-ubyte.gz"
}

ORIG_DIR = Path(sys.argv[1])
RESZ_DIR = Path(sys.argv[1])
SHAPE = (64, 64)

try:
    ORIG_DIR.mkdir()
except FileExistsError as e:
    pass
try:
    RESZ_DIR.mkdir()
except FileExistsError as e:
    pass


for url, name in FASHION_MNIST.items():
    dst = ORIG_DIR / name
    urllib.request.urlretrieve(url, dst.as_posix())

train, labels = load_mnist(ORIG_DIR.as_posix(), rows=28, cols=28, kind='train')
resized = np.empty((train.shape[0],) + SHAPE, train.dtype)
for i, img in enumerate(train[:]):
    big = transform.resize(img[0] / 256.0, SHAPE,
                           mode='constant', cval=0) * 256
    big = big.astype(np.uint8)
    resized[i][:][:] = big
store_mnist(RESZ_DIR.as_posix(), resized, labels, "train-64")


t10k, labels = load_mnist(ORIG_DIR.as_posix(), rows=28, cols=28, kind='t10k')
resized = np.empty((t10k.shape[0],) + SHAPE, t10k.dtype)
for i, img in enumerate(t10k[:]):
    big = transform.resize(img[0] / 256.0, SHAPE,
                           mode='constant', cval=0) * 256
    big = big.astype(np.uint8)
    resized[i][:][:] = big
store_mnist(RESZ_DIR.as_posix(), resized, labels, "t10k-64")

for _, name in FASHION_MNIST.items():
    path = ORIG_DIR / name
    os.remove(path.as_posix())
