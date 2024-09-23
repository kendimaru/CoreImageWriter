CoreImageWriter
===============

Write CIImage to a file easily.

.. image:: https://img.shields.io/badge/License-MIT-yellow.svg
    :alt: MIT License


Install
-------

Set GitHub repository URL using Swift Package Manager.

1. In XCode project, select File > Add Package Dependencies then a dialog come.
2. Enter `https://github.com/kendimaru/CoreImageWriter.git` in search box at upper right of window, press Enter.


How To Use
----------

    let img = CIImage(contentsOf: urlFrom)!
    let writer = CoreImageWriter()
    let urlTo = URL(
        filePath: "somedir/dest.jpg", // .png is also accepted
        relativeTo: URL.homeDirectory)
    try! writer.write(image: img, to: urlTo)


License
-------

CoreImageWriter is available under the MIT license.
