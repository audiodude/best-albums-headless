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
$ bundle exec cap production invoke:rake TASK=best_albums:build
```

## Deploying the static app

To deploy the static app at bestalbumsintheuniverse.com, use this command:

```bash
$ bundle exec cap production invoke:rake TASK=best_albums:deploy_web
```

## Deploying the gemini site

To deploy the gemini site at gem.bestalbumsintheuniverse.com, use this command:

```bash
$ bundle exec cap production invoke:rake TASK=best_albums:deploy_gem
```
