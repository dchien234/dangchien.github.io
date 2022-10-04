# Personal Blog

## Setup with GitHub Pages & Jekyll

[Setting up your GitHub Pages site locally with Jekyll](https://help.github.com/en/articles/setting-up-your-github-pages-site-locally-with-jekyll#step-1-create-a-local-repository-for-your-jekyll-site)

### Prerequisite

```bash
ruby --version
gem --version
gem install bundler
bundle install
```

### Develop

```bash
bundle exec jekyll serve --incremental
```

**How to add a new gem to `Gemfile`?**
```bash
bundle add webrick
```

### Update

**How to update the bundler version in a `Gemfile.lock`?**
```bash
# Install the latest bundler version
gem install bundler

# Update the bundler version in Gemfile.lock
bundle update --bundler

# Confirm it worked
tail -n2 Gemfile.lock
```

**How to update a particular gem in `Gemfile`?**
```bash
bundle update github-pages
# or
bundle update
```

**How to update all default gems in the system?**
```bash
gem update --system
```

## Authors

[1.1]: http://i.imgur.com/wWzX9uB.png "follow me on twitter"
[2.1]: http://i.imgur.com/9I6NRUm.png "follow me on github"

[1]: https://twitter.com/dangchien87
[2]: https://github.com/dchien234

- Dang Chien [![alt text][1.1]][1][![alt text][2.1]][2]
