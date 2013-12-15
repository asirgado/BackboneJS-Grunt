## BackboneJs Environment v2.0.0 ##
Environment is installed via npm, the Node.js, tasks via Grunt.js and dependencies with Bower.

### Coffeescript + HAML + SASS ###

##### includes: #####
* RequireJS + jquery + !text plugin
* BackboneJS
* UnderscoreJS
* Twitter Bootstrap
* MomentJs
* Spin.js
* jQuery UI
* VisualSearch


#### Fetch dependencies ####
```
npm install
```


Initialize a project.. fetches dependencies and creates an example scaffolding
run
```
grunt init
```
open `application/httpdocs/` in the browser and check console


#### Watching for changes is the default task in Grunt: ####
```
grunt
```

#### Build ####
To compile all assets on a `dist/` folder, ready for deploy.
```
grunt build
```

December 2013