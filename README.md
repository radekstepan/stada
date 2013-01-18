# Staða

Your data, your achievements, your points.

![image](https://github.com/radekstepan/stada/raw/master/example.png)

## Getting started

Start the MongoDB:

```bash
$ sudo mongod
```

Install the package dependencies:

```bash
$ npm install -d
```

Start the server and compile client side app watching for changes:

```bash
$ npm start
```

Or more explicitly:

```bash
$ node ./node_modules/brunch/bin/brunch watch --server
```

The port to start on is set in `config.coffee`.

## Troubleshooting

### NPM

Update to the latest NPM:

```bash
$ sudo npm update npm -g
```

### Growl

Install [libnotify](http://growl.info/extras.php#growlnotify) to see Growl notifications on `brunch --watch`.

### Brunch auto-reload plugin

The plugin did not work for me and the only way to make it was to copy the `node_modules/auto-reload-brunch/vendor/auto-reload.js` file into the main `vendor` directory. Now I see a connection to the WebSockets server.