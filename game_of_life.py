#!/venv/bin/ python

import numpy as np
from scipy import signal
import matplotlib.pyplot as plt
from matplotlib.widgets import Button, Slider
import math
import matplotlib.animation as animation


class Game():
    ""
    def __init__(self, size = (20, 200), inside = "random"):
        self.filter = fp = np.array([[1, 1, 1],
                                     [1, 0, 1],
                                     [1, 1, 1]], np.uint8)
        self.in_process = False
        self.fig = plt.figure()
        # self.fig, self.ax = plt.subplots(figsize=(6,7),)
        # self.animation_ax = plt.subplot2grid((6,7), (0, 0), colspan=6, rowspan=6)
        # button_ax = plt.subplot2grid((6,7), (0, 6), rowspan=1)
        # button_1ax = plt.subplot2grid((6,7), (1, 6), rowspan=1)
        self.animation_ax = self.fig.add_axes([.05, .05, .8, .9])
        self.animation_ax.axis('off')

        # sld_size_ax = self.fig.add_axes([.85, .3, .15, .03])
        # sld_size = Slider(sld_size_ax, 'Size', size[0], size[1], valinit=np.mean(size), valfmt=u'%0.0f', dragging=True)
        # sld_size.on_changed(self.sld_size_callback)

        btn_draw_ax = self.fig.add_axes([.85, .2, .1, .1])
        btn_draw = Button(btn_draw_ax, 'ginput')
        btn_draw.on_clicked(self.btn_draw_callback)

        button_1ax = self.fig.add_axes([.85, .1, .1, .1])
        goutput = Button(button_1ax, 'goutput')
        goutput.on_clicked(self.goutput_callback)
        self.size = np.mean(size)
        if inside == "random":
            self.field = np.random.randint(2, size=(self.size,self.size))
        elif inside == "empty":
            self.field = np.zeros((self.size, self.size))
        self.im = self.animation_ax.imshow(self.field, cmap=plt.cm.gray, interpolation='nearest')


    def goutput_callback(self, event):
        self.in_process = False

    # def sld_size_callback(self, val):
    #     self.size = val
    #     # self.animation_ax.set_ylim([val, 0])
    #     # self.animation_ax.set_xlim([0, val])
    #     # self.animation_ax.autoscale_view(True,True,True)
    #     self.animation_ax.relim()
    #     self.field.resize((val,val), refcheck=False)
        

    def btn_draw_callback(self, event):
        self.in_process = True
        while self.in_process:
            y, x = [math.floor(val+0.499) for val in plt.ginput(1)[0]]
            print(x,y, len(self.field), self.field[x, y])
            self.field[x, y] = self.field[x, y] == 0

    def __str__(self):
        pass

    def  play(self, *args):
        if not self.in_process:
            conv_field = signal.convolve2d(self.field, self.filter, boundary='symm', mode='same')
            self.field = np.array(np.logical_or(np.logical_and(self.field == 1, np.logical_and(conv_field > 1, conv_field < 4)),
                                    np.logical_and(self.field == 0, conv_field == 3))).astype(int)
            self.im.set_array(self.field)
        else:
            self.im.set_array(self.field)
        print(len(self.field))
        return self.im,

    def rendering(self, delay = 2):
        self.ani = animation.FuncAnimation(self.fig, self.play, interval=200, blit=True)
        plt.show()




if __name__ == "__main__":
    game = Game()
    game.rendering()