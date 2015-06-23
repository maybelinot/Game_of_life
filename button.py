import matplotlib.pyplot as plt
from matplotlib.widgets import Button
from matplotlib.gridspec import GridSpec
def btncallback(event):
	ax2.plot([1, 2,3,4,5], [1, 2,3,4,5])

plt.figure()

gs = GridSpec(6, 6)
ax2 = plt.subplot2grid((6,6), (0, 0), colspan=5, rowspan=6)
ax3 = plt.subplot2grid((6,6), (0, 5), rowspan=1)
bb = Button(ax3,'trghrt')

bb.on_clicked(btncallback)



plt.show()


