# dic

dic is the tool to allow you to edit the wiki repository.

# Installation
```
./installer
```

# Usage
The following command can help you create the new page.

```
$ dic -n [word]
```

To edit the already existing page,

```
$ dic [word]
```

* To note, with this option if there are no matches to the word, it automatically generates the new file instead.

Help option:

```
$ dic -h
```


To delete the article,

```
$ dic -d
```

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


# Donation

Please check out "keita roimo" on iTunes, Amazon, or Spotify.
