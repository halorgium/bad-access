# Bad Access

## Motivation

Real.com scares me to death. I found a video I wanted to watch, but it was in some arcane RealMedia format.

I wanted to watch it even with the crazy format it was in, so I created a non-admin user to install the program in.

After doing this, I found that the non-admin user had write access to a whole bunch of my files and also a whole bunch of system files.
This scared me a bunch, so I decided to hack something together to trawl the filesystem and tell me which files were essentially world-writable.

## Usage

First you will need to create a non-admin user.

On a mac, you can do this in System Preferences / Accounts.

Then, execute `./setup USERNAME` to get the repo up and running.

Now, execute `./run` and follow the instructions.
