set cbrange[1.5:5.5]
set xrange [0:99]; set yrange [0:99]
plot '03210.raw' binary array=100x100 format="%float" with image
