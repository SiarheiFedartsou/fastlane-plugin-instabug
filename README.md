# [Instabug](https://instabug.com/) plugin
[![CI Status](http://img.shields.io/travis/SiarheiFedartsou/fastlane-plugin-instabug.svg?style=flat)](https://travis-ci.org/SiarheiFedartsou/fastlane-plugin-instabug)
[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-instabug)

## Getting Started

This project is a [fastlane](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-instabug`, add it to your project by running:

```bash
fastlane add_plugin instabug
```

## About instabug

Uploads dSYM to [Instabug](https://instabug.com/)

## Actions

### instabug

```ruby
instabug(api_token: 'INSTABUG_TOKEN',
# DSYM_OUTPUT_PATH by default (produced by gym command).
# Should be *.zip-file, if not it will be zipped automatically
         dsym_path: '/path/to/dsym')
```

For more information see `fastlane action instabug`.

## Run tests for this plugin

To run both the tests, and code style validation, run

````
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://github.com/fastlane/fastlane/blob/master/fastlane/docs/PluginsTroubleshooting.md) doc in the main `fastlane` repo.

## Using `fastlane` Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://github.com/fastlane/fastlane/blob/master/fastlane/docs/Plugins.md).

## About `fastlane`

`fastlane` is the easiest way to automate building and releasing your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
