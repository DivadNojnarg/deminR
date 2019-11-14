// Import Workbox (https://developers.google.com/web/tools/workbox/)
importScripts('https://storage.googleapis.com/workbox-cdn/releases/3.6.3/workbox-sw.js');

/*
  Precache Manifest
Change revision as soon as file content changed
*/
  self.__precacheManifest = [
    {
      revision: '1',
      url: 'framework7-5.1.1/framework7.bundle.min.css'
    },
    {
      revision: '1',
      url: 'framework7-5.1.1/material-icons.css'
    },
    {
      revision: '1',
      url: 'framework7-5.1.1/framework7.bundle.min.js'
    },
    {
      revision: '1',
      url: 'framework7-5.1.1/my-app.css'
    },
    {
      revision: '1',
      url: 'framework7-5.1.1/framework7-icons.css'
    },
    {
      revision: '1',
      url: 'framework7-5.1.1/my-app.js'
    },
    // Fonts
    {
      revision: '1',
      url: 'fonts/Framework7Icons-Regular.woff2'
    },
    {
      revision: '1',
      url: 'fonts/Framework7Icons-Regular.woff'
    },
    {
      revision: '1',
      url: 'fonts/Framework7Icons-Regular.eot'
    },
    {
      revision: '1',
      url: 'fonts/Framework7Icons-Regular.ttf'
    },
    // HTML
    {
      revision: '1',
      url: 'https://dgranjon.shinyapps.io/deminR/'
    },
    // Icons
    {
      revision: '1',
      url: 'icons/128x128.png'
    },
    {
      revision: '1',
      url: 'icons/144x144.png'
    },
    {
      revision: '1',
      url: 'icons/152x152.png'
    },
    {
      revision: '1',
      url: 'icons/192x192.png'
    },
    {
      revision: '1',
      url: 'icons/256x256.png'
    },
    {
      revision: '1',
      url: 'icons/512x512.png'
    },
    {
      revision: '1',
      url: 'icons/favicon.png'
    },
    {
      revision: '1',
      url: 'icons/apple-touch-icon.png'
    }
  ];

/*
  Enable precaching
It is better to comment next line during development
*/
  workbox.precaching.precacheAndRoute(self.__precacheManifest || []);
