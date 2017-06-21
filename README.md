# voltaire

voltaire is the tool to allow you to edit the wiki repository.

# Installation
```
./installer
```

# Usage
The following command can help you create the new page.

```
$ vol -n [word]
```

To edit the already existing page,

```
$ vol [word]
```

* To note, with this option if there are no matches to the word, it automatically generates the new file instead.

Help option:

```
$ vol -h
```

To delete the article,

```
$ vol -d
```

To add image and copy the markup link to your clipboard

```
$ vol -i [image.jpg]
```

then if you can paste it onto any .md page, image will be embedded.

To update your change in wiki:
```
$ vol -u
```

Grep search:

```
$ vol -g [term1] [term2],,,
```
Then you can retrieve the list of corresponding articles


# URL Configuration

Once you pushed your **wiki repository** in your **github repository**, then you have to edit the config.

```
$ cp etc/config.sample etc/config
$ vim etc/config
```

Then install it again:

```
$ ./installer
```

# Testing

```

$ ./test/yaru
```


# Donation

Please check out "keita roimo" on iTunes, Amazon, or Spotify.
