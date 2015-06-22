#!/venv/bin/ python

import numpy as np
from scipy import signal
import matplotlib.pyplot as plt
import matplotlib.animation as animation

class Game():
    ""
    def __init__(self, size = 20, inside = "random"):
        self.filter = fp = np.array([[1, 1, 1],
                                     [1, 0, 1],
                                     [1, 1, 1]], np.uint8)
        self.fig = plt.figure()
        self.size = size
        if inside == "random":
            self.field = np.random.randint(2, size=(size,size))
        elif inside == "empty":
            self.field = np.zeros((size, size))
        self.im = plt.imshow(self.field, cmap=plt.cm.gray, interpolation='nearest')

    def __str__(self):
        pass

    def  play(self, *args):
        conv_field = signal.convolve2d(self.field, self.filter, boundary='symm', mode='same')
        self.field = np.array(np.logical_or(np.logical_and(self.field == 1, np.logical_and(conv_field > 1, conv_field < 4)),
                                np.logical_and(self.field == 0, conv_field == 3))).astype(int)
        self.im.set_array(self.field)
        return self.im,

    def rendering(self, delay = 2):
        self.ani = animation.FuncAnimation(self.fig, self.play, interval=50, blit=True)
        plt.show()





if __name__ == "__main__":
    game = Game()
    game.play()
    game.rendering()