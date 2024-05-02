# Description

Simple shell script to embed a preseed.cfg into a given Debian ISO file. Packaged using Docker.

Source code is tiny and hopefully readable, so it should be easy to audit and/or adjust things
to your needs if necessary.

## Requirements

- Docker
- A Debian ISO file
- A preseed.cfg file

## Usage

1. Clone the repo
2. `cd` into it
3. Run this:

```bash
./build.sh ./path-to-debian.iso ./path-to-preseed.cfg ./output-dir
```

The script will not modify your provided Debian ISO or preseed.cfg, it
will just put its outputs in the output directory that you specify when calling it.
