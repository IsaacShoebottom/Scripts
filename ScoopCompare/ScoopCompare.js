// Run with node

// Read ~/scoop/apps.json and compare it to scoop export
// Then display the differences in the installed apps and the apps.json file

// read apps.json file
let fs = require('fs');
let apps = fs.readFileSync('C:/Users/Isaac/scoop/apps.json', 'utf8');
apps = JSON.parse(apps);
apps = apps.apps;

// run scoop export in shell and save output to variable
let { execSync } = require('child_process');
let installedApps = execSync('scoop export').toString();
installedApps = JSON.parse(installedApps);
installedApps = installedApps.apps;

// Make a set out of each of the arrays on the Name property
let appsSet = new Set(apps.map(app => app.Name));
let installedAppsSet = new Set(installedApps.map(app => app.Name));

// Find the difference between the two sets
let diffFromInstalledApps =  new Set([...appsSet].filter(x => !installedAppsSet.has(x)));
let diffFromApps = new Set([...installedAppsSet].filter(x => !appsSet.has(x)));
console.log("Apps in apps.json but not installed: ", diffFromInstalledApps);
console.log("Apps installed but not in apps.json: ", diffFromApps);