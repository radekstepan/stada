# Staða

Your data, your achievements, your points.

## Troubleshooting

## NPM

Update to the latest NPM:

```bash
$ sudo npm update npm -g
```

### Growl

Install [libnotify](http://growl.info/extras.php#growlnotify) to see Growl notifications on `brunch --watch`.

### Brunch auto-reload plugin

The plugin did not work for me and the only way to make it was to copy the `node_modules/auto-reload-brunch/vendor/auto-reload.js` file into the main `vendor` directory. Now I see a connection to the WebSockets server.