# redux-gifs

This is some pretty un-loved code that hits the BBC Redux API, runs a search for programmes of a particular title, grabs a frame from *x* seconds into the programme, and stitches them all into a GIF.

For example:

![](https://raw.githubusercontent.com/samstarling/redux-gifs/master/examples/example.gif)

### TODO

* Use ImageMagick to stitch together a GIF, rather than `gif_maker.rb`.
* Tidy up the structure of the project.

### ImageMagick

This is for later reference:

    convert -delay 1x12 output/*.jpg \
              -ordered-dither o8x8,4 \
              -coalesce -layers OptimizeTransparency \
              -loop 0 \
              +map examples/example.gif
