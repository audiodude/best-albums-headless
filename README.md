# Headless CMS for https://bestalbumsintheuniverse.com

## Overview

Building off the [original version](https://github.com/audiodude/best-albums) of this site, the current version
attempts to streamline the editing and image capturing workflows. To this end, the admin interface, written
in Ruby on Rails, is deployed to a cloud service along with the site database. The served site is still static,
and still depends on an albums.json file served from its root.

For more information on this project, see my [digital garden](https://garden.travisbriggs.com/garden/best%20albums%20in%20the%20universe/)

## Building the albums.json for the static website

The static website at bestalbumsintheuniverse.com reads from a static albums.json file in order to display the albums.

First, setup your Ruby environment so that you can run the Capistrano `cap` command.

Then, configure your `~/.ssh/config` file so that Capistrano can do a non-interactive login to the production machine:

```
Host admin.bestalbumsintheuniverse.com
  User best-albums-headless
  IdentityFile ~/.ssh/YOUR_PRIVATE_KEY
```

Finally, use the following command from this directory:

```bash
bundle exec cap production invoke:rake TASK=best_albums:build
```

## Deploying the static app

To deploy the static app at bestalbumsintheuniverse.com, use this command:

```bash
bundle exec cap production invoke:rake TASK=best_albums:deploy_web
```

## Deploying the gemini site

To deploy the gemini site at gem.bestalbumsintheuniverse.com, use this command:

```bash
bundle exec cap production invoke:rake TASK=best_albums:deploy_gem
```

## Broken ASDF

If you're using ASDF on macOS and it seems broken, aka you're getting error messages like:

```
/System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/2.6.0/rubygems.rb:283:in `find_spec_for_exe': Could not find 'bundler' (2.5.11) required by your /Users/tmoney/code/best-albums-headless/Gemfile.lock. (Gem::GemNotFoundException)
To update to the latest version installed on your system, run `bundle update --bundler`.
To install the missing version, run `gem install bundler:2.5.11`
```

You can prefix with `asdf exec`, like this:

```bash
asdf exec bundle exec ...
```

## Capistrano ASDF wrapper

If you get the following error when doing a `cap` command:

```
rake stderr: bash: line 1: /var/www/best-albums-headless/shared/asdf-wrapper: No such file or directory
```

Make sure the ASDF wrapper is installed on the server with:

```bash
cap production asdf:upload_wrapper
```
