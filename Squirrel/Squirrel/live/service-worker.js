/**
 * Copyright 2016 Google Inc. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
*/

// DO NOT EDIT THIS GENERATED OUTPUT DIRECTLY!
// This file should be overwritten as part of your build process.
// If you need to extend the behavior of the generated service worker, the best approach is to write
// additional code and include it using the importScripts option:
//   https://github.com/GoogleChrome/sw-precache#importscripts-arraystring
//
// Alternatively, it's possible to make changes to the underlying template file and then use that as the
// new base for generating output, via the templateFilePath option:
//   https://github.com/GoogleChrome/sw-precache#templatefilepath-string
//
// If you go that route, make sure that whenever you update your sw-precache dependency, you reconcile any
// changes made to this original template file with your modified copy.

// This generated service worker JavaScript will precache your site's resources.
// The code needs to be saved in a .js file at the top-level of your site, and registered
// from your pages in order to be used. See
// https://github.com/googlechrome/sw-precache/blob/master/demo/app/js/service-worker-registration.js
// for an example of how you can register this script and handle various service worker events.

/* eslint-env worker, serviceworker */
/* eslint-disable indent, no-unused-vars, no-multiple-empty-lines, max-nested-callbacks, space-before-function-paren, quotes, comma-spacing */
'use strict';

var precacheConfig = [["/bower_components/app-layout/app-drawer-layout/app-drawer-layout.html","a088b9caa8c8580ec7c6bea4fd6e01ed"],["/bower_components/app-layout/app-drawer/app-drawer.html","182160ee73638fabfe328bc98dd7f9c4"],["/bower_components/app-layout/app-header-layout/app-header-layout.html","bb58d670f74b91214c31050ad851906a"],["/bower_components/app-layout/app-layout-behavior/app-layout-behavior.html","4803cb1f67919ff1c9ce0eb1944153f4"],["/bower_components/app-layout/app-scroll-effects/app-scroll-effects-behavior.html","fc72538a2ea03edaf275238a97b21bc8"],["/bower_components/app-layout/app-scroll-effects/app-scroll-effects.html","334eac7f54a828baedbe8f09574571b7"],["/bower_components/app-layout/app-scroll-effects/effects/blend-background.html","53ab90982adbe7457d8603d722c98d2f"],["/bower_components/app-layout/app-scroll-effects/effects/fade-background.html","593bd7855bcc277f33e8c256c45ef039"],["/bower_components/app-layout/app-scroll-effects/effects/material.html","09fc23898ebd40bf11160760df03de86"],["/bower_components/app-layout/app-scroll-effects/effects/parallax-background.html","d50c47e6d50fe8a33e65d10a9c189684"],["/bower_components/app-layout/app-scroll-effects/effects/resize-snapped-title.html","a9dcfcb21b7af4dbe25d8ca6d8099463"],["/bower_components/app-layout/app-scroll-effects/effects/resize-title.html","572428f1f51fd78b90c1e867e9cb33c4"],["/bower_components/app-layout/app-scroll-effects/effects/waterfall.html","0d19840e1b4112985dacaf8a99513abe"],["/bower_components/app-layout/helpers/helpers.html","cdd968e67df0b732f9d47057af41e73f"],["/bower_components/app-route/app-location.html","734b06f3c15a9df75277d372f746694b"],["/bower_components/app-route/app-route-converter-behavior.html","5ed794fad917e6c6cae8ecc2da6a1840"],["/bower_components/app-route/app-route.html","7e0b3dc18212e19edfadfb43aba5687a"],["/bower_components/eth-util-browserified/eth-util.min.js","a1438f4b4dcd850748fbc10b7f108ef5"],["/bower_components/font-roboto/roboto.html","754bfa07bd18fb78cf50fb9fede72272"],["/bower_components/iron-a11y-announcer/iron-a11y-announcer.html","7da2a1b06dbf5fc05631df208da0ba8b"],["/bower_components/iron-a11y-keys-behavior/iron-a11y-keys-behavior.html","26309806bc5a08dab92ec43a33bf85ad"],["/bower_components/iron-autogrow-textarea/iron-autogrow-textarea.html","df0738cbb5484fcc310bd9c689056aa6"],["/bower_components/iron-behaviors/iron-control-state.html","07c184ff119f2fef2f8fb113e44538fc"],["/bower_components/iron-flex-layout/iron-flex-layout.html","31abc906fe092d26e37933efd43d7977"],["/bower_components/iron-form-element-behavior/iron-form-element-behavior.html","e9055514fc97f36ae6642d998c9ff809"],["/bower_components/iron-input/iron-input.html","ae41aa86cffa3d4308074518f732ba54"],["/bower_components/iron-location/iron-location.html","1d9093461efeaa418df84aacffd3515a"],["/bower_components/iron-location/iron-query-params.html","5e10cc028701b213de7790f68a3140c6"],["/bower_components/iron-media-query/iron-media-query.html","81acb2abcf1ad3a7636fce5c43f0fcb5"],["/bower_components/iron-meta/iron-meta.html","706d2c47bdd19b3dc9e041db7098af93"],["/bower_components/iron-pages/iron-pages.html","0bcbc3ee4469ff26099a1ab1066afca0"],["/bower_components/iron-resizable-behavior/iron-resizable-behavior.html","274c34854d7b23294f7bcdefe0f3a052"],["/bower_components/iron-scroll-target-behavior/iron-scroll-target-behavior.html","b9ed296f3e22b0f5701774d1f5d33caf"],["/bower_components/iron-selector/iron-selectable.html","cef4915b5c80a37cd8a869c86a35956e"],["/bower_components/iron-selector/iron-selection.html","3343a653dfada7e893aad0571ceb946d"],["/bower_components/iron-validatable-behavior/iron-validatable-behavior.html","a6a37bc8044afa71735830f59595057a"],["/bower_components/paper-input/paper-input-addon-behavior.html","00856186c5e3849d76e77b0bf9496584"],["/bower_components/paper-input/paper-input-behavior.html","704d1abc0eeddeecc130a42a819883cc"],["/bower_components/paper-input/paper-input-char-counter.html","363e363cc3172e55f53f81b2a154a495"],["/bower_components/paper-input/paper-input-container.html","eb8295ee8f781abe84df1a57d5892109"],["/bower_components/paper-input/paper-input-error.html","89e727945e8095c4b24baadd2d98b1b9"],["/bower_components/paper-input/paper-input.html","581db58dfc0358b5242d80b8036be3a1"],["/bower_components/paper-input/paper-textarea.html","859f9907f6b5f3e26f1abf66b73ff929"],["/bower_components/paper-styles/color.html","e3e3c43a7fa75c3a2f8a395ae8fd490d"],["/bower_components/paper-styles/default-theme.html","ed4df18f1171d7793508d645054335b8"],["/bower_components/paper-styles/typography.html","ec83aab763eb945a808c7b4c400a1b34"],["/bower_components/poly-eth/poly-eth-address.html","665f5761f2e7ec2c05d169d17d62f924"],["/bower_components/poly-eth/poly-eth-balance.html","983642b66c57ceb09fc90b2caca145e5"],["/bower_components/poly-eth/poly-eth-join.html","b728439ca0c8efd15a1c64b3e8e14acc"],["/bower_components/poly-eth/poly-eth-login.html","db3e3ad20149ed16d5badcb6704c25eb"],["/bower_components/poly-eth/poly-eth-passphrase.html","ba569c68ef7377d2442807ef5af91d99"],["/bower_components/poly-eth/poly-eth-restore.html","608d3afe9f5d3921c6ba41189ba4ac5b"],["/bower_components/poly-eth/poly-eth-send.html","a37bfbe6a4302c512609bad107e335c4"],["/bower_components/poly-eth/poly-eth.html","222303fe39c87ebebb987ea249856366"],["/bower_components/polymer-redux/dist/polymer-redux.html","d834bf6020e0853fddf54e1e23f3e791"],["/bower_components/polymer-redux/polymer-redux.html","a726fb40665c520a50f9e0114d86ab7f"],["/bower_components/polymer/lib/elements/array-selector.html","a500d1070d2637e858844d8a1a43658c"],["/bower_components/polymer/lib/elements/custom-style.html","5f3b28865d7f8a469ee745438f6eb8d9"],["/bower_components/polymer/lib/elements/dom-bind.html","a6533d5f17565a97a67fd53a6cf80d81"],["/bower_components/polymer/lib/elements/dom-if.html","847fb578e0b1f7c3947dba2736029da8"],["/bower_components/polymer/lib/elements/dom-module.html","d7df9a0ee9d0f4978b5df9f30be3d339"],["/bower_components/polymer/lib/elements/dom-repeat.html","46e83344864dc778c57baf81ca21a157"],["/bower_components/polymer/lib/legacy/class.html","e1388e54727915d7e67fe5919de62524"],["/bower_components/polymer/lib/legacy/legacy-element-mixin.html","a302d688f1ddc3109e556882b52e2499"],["/bower_components/polymer/lib/legacy/mutable-data-behavior.html","bb4f75ba9c1cdc662c30ac2dcab6866f"],["/bower_components/polymer/lib/legacy/polymer-fn.html","34bedf8d4b761dfe01f3d64285efba1a"],["/bower_components/polymer/lib/legacy/polymer.dom.html","e3f165bcf2d187874fe0d66c61b51b4c"],["/bower_components/polymer/lib/legacy/templatizer-behavior.html","e5c89425dc864115ab3d7ad21cc2b0ff"],["/bower_components/polymer/lib/mixins/element-mixin.html","ac8a51ed415bf4e4831791b5364fae96"],["/bower_components/polymer/lib/mixins/gesture-event-listeners.html","e50053979e0059c314aac6870f59033c"],["/bower_components/polymer/lib/mixins/mutable-data.html","4b1bc463f806d01f4eb9fa69fb073f4c"],["/bower_components/polymer/lib/mixins/property-accessors.html","3c64ef1c917a88f01edd76df58c52add"],["/bower_components/polymer/lib/mixins/property-effects.html","857be40b6f04910c94396197fa2e1560"],["/bower_components/polymer/lib/mixins/template-stamp.html","3f058adadd5d0b611b13184716e4500f"],["/bower_components/polymer/lib/utils/array-splice.html","90f614cea12207217715e6c0cdd21b84"],["/bower_components/polymer/lib/utils/async.html","7e00a54867ddbc372a439839002c8556"],["/bower_components/polymer/lib/utils/boot.html","7c1bc24be1c3e1e6dd2138065f3c70d8"],["/bower_components/polymer/lib/utils/case-map.html","397d495f3eb392b59a65dfee0421b305"],["/bower_components/polymer/lib/utils/debounce.html","e9a0947e89175de8edae7b4abd82cdb4"],["/bower_components/polymer/lib/utils/flattened-nodes-observer.html","3bed80f952ae3de0026a1cefebc94893"],["/bower_components/polymer/lib/utils/flush.html","5e9e55d5e5d7d88bfe3073f4536331ea"],["/bower_components/polymer/lib/utils/gestures.html","69bf581df50dbc0847907c458310c9e0"],["/bower_components/polymer/lib/utils/import-href.html","30ae384601a5c5863e0ee5dab48e0c82"],["/bower_components/polymer/lib/utils/mixin.html","b2b11ece98ca57fccdfabc2b959a12eb"],["/bower_components/polymer/lib/utils/path.html","31282a720fd5ac4bcd0d0b9b63329c00"],["/bower_components/polymer/lib/utils/render-status.html","5c3bcc9bc9b589afe0aac2deba1ac214"],["/bower_components/polymer/lib/utils/resolve-url.html","15810a3ba447c460502e9cf7f04b64b5"],["/bower_components/polymer/lib/utils/style-gather.html","c93b973e76f604ce53f6686552906cd8"],["/bower_components/polymer/lib/utils/templatize.html","24467dfb5850dbde7eb7cd43d99d956f"],["/bower_components/polymer/lib/utils/unresolved.html","bea349c4a71e9f4327da774afd73f8ae"],["/bower_components/polymer/polymer-element.html","3bd40d53906e45bae18a99177e00eb48"],["/bower_components/polymer/polymer.html","edc45d69a352ab2bcb32048524c02573"],["/bower_components/qrcode-generator/qrcode-generator.html","8a9828b598521939b4fc7beb20b2c415"],["/bower_components/shadycss/apply-shim.html","a7855a6be7cd2ceab940f13c1afba1f3"],["/bower_components/shadycss/apply-shim.min.js","6b47e16c654d1686c4c8359a98a16045"],["/bower_components/shadycss/custom-style-interface.html","7784f566f143bec28bf67b864bedf658"],["/bower_components/shadycss/custom-style-interface.min.js","3d87ce64588ea9a73f62dbe8d75990ce"],["/bower_components/web3/dist/web3.min.js","782daf0e447dfd9e73476b409ae98991"],["/bower_components/webcomponentsjs/custom-elements-es5-adapter.js","76bf14c68e996daeddf9d8ec2ee46edb"],["/bower_components/webcomponentsjs/gulpfile.js","5b9593e6c3a2a87a866c1169114c745e"],["/bower_components/webcomponentsjs/webcomponents-hi-ce.js","ca1006109a6ea5de2ad25cee8e41dbdf"],["/bower_components/webcomponentsjs/webcomponents-hi-sd-ce.js","b92e4771412e4d615b57efdf366309e4"],["/bower_components/webcomponentsjs/webcomponents-hi.js","8fd458d84ef0f9c3fa4f0b64a7222b06"],["/bower_components/webcomponentsjs/webcomponents-lite.js","4cbc68ade3424dca67aaa83d66b87f88"],["/bower_components/webcomponentsjs/webcomponents-loader.js","f13bbbbf647b7922575a7894367ddaaf"],["/bower_components/webcomponentsjs/webcomponents-sd-ce.js","cc48715b0616b1d66a0c94ca02d06f78"],["/index.html","801ee76009f21ea13a18317e74a5212c"],["/manifest.json","fbe819261b8fdf0d03f84ddedf5f3f0e"],["/node_modules/redux/dist/redux.min.js","c379220604b78bfef9a65b1d55f92041"],["/src/my-address.html","553d1941971b81b8a8f768401e0fcab4"],["/src/my-balance.html","c5c555a5cfe1dbe1fdc88003b5183f34"],["/src/my-confirm.html","686133d579162021ac3115a6f0d96d03"],["/src/my-contacts.html","a12f16438d02a1e6af364ca0310bb752"],["/src/my-dapp.html","6a99c895a958301258007d52f1899863"],["/src/my-delivered.html","d7570eda9c8365c4bc7615bd2e4031b7"],["/src/my-join.html","ca178e2ee5494c14874d9e4f8f007a5a"],["/src/my-loading.html","3e533101e33e3bba700ec24d13a60dcd"],["/src/my-login.html","6ea9c6fd9053bc53c46344cefd996105"],["/src/my-phrase.html","8f833aebb6b940e361e5d57cb4ff7a71"],["/src/my-redux.html","8a6ddccb193bf4d806c0eca9a7fc7f85"],["/src/my-restore.html","579789f137e29f067d3ff10970e60547"],["/src/my-scan.html","2bce49063a8d65a8ad344a68d18c9f6c"],["/src/my-send.html","7f07e7e4e8e826ed80d35f231f0f9287"],["/src/my-transactions.html","ccdb3ab89167f5eb40afc66095f5ad5c"],["/src/my-view404.html","9c33efbfe408b666989355630bcd9922"],["/src/my-warning.html","05ba92278c09e35fee4c41b4bb962e53"],["/src/shared-styles.html","d383aaa7036f329f1a3af79e6e80fcea"]];
var cacheName = 'sw-precache-v2--' + (self.registration ? self.registration.scope : '');


var ignoreUrlParametersMatching = [/^utm_/];



var addDirectoryIndex = function (originalUrl, index) {
    var url = new URL(originalUrl);
    if (url.pathname.slice(-1) === '/') {
      url.pathname += index;
    }
    return url.toString();
  };

var createCacheKey = function (originalUrl, paramName, paramValue,
                           dontCacheBustUrlsMatching) {
    // Create a new URL object to avoid modifying originalUrl.
    var url = new URL(originalUrl);

    // If dontCacheBustUrlsMatching is not set, or if we don't have a match,
    // then add in the extra cache-busting URL parameter.
    if (!dontCacheBustUrlsMatching ||
        !(url.toString().match(dontCacheBustUrlsMatching))) {
      url.search += (url.search ? '&' : '') +
        encodeURIComponent(paramName) + '=' + encodeURIComponent(paramValue);
    }

    return url.toString();
  };

var isPathWhitelisted = function (whitelist, absoluteUrlString) {
    // If the whitelist is empty, then consider all URLs to be whitelisted.
    if (whitelist.length === 0) {
      return true;
    }

    // Otherwise compare each path regex to the path of the URL passed in.
    var path = (new URL(absoluteUrlString)).pathname;
    return whitelist.some(function(whitelistedPathRegex) {
      return path.match(whitelistedPathRegex);
    });
  };

var stripIgnoredUrlParameters = function (originalUrl,
    ignoreUrlParametersMatching) {
    var url = new URL(originalUrl);

    url.search = url.search.slice(1) // Exclude initial '?'
      .split('&') // Split into an array of 'key=value' strings
      .map(function(kv) {
        return kv.split('='); // Split each 'key=value' string into a [key, value] array
      })
      .filter(function(kv) {
        return ignoreUrlParametersMatching.every(function(ignoredRegex) {
          return !ignoredRegex.test(kv[0]); // Return true iff the key doesn't match any of the regexes.
        });
      })
      .map(function(kv) {
        return kv.join('='); // Join each [key, value] array into a 'key=value' string
      })
      .join('&'); // Join the array of 'key=value' strings into a string with '&' in between each

    return url.toString();
  };


var hashParamName = '_sw-precache';
var urlsToCacheKeys = new Map(
  precacheConfig.map(function(item) {
    var relativeUrl = item[0];
    var hash = item[1];
    var absoluteUrl = new URL(relativeUrl, self.location);
    var cacheKey = createCacheKey(absoluteUrl, hashParamName, hash, false);
    return [absoluteUrl.toString(), cacheKey];
  })
);

function setOfCachedUrls(cache) {
  return cache.keys().then(function(requests) {
    return requests.map(function(request) {
      return request.url;
    });
  }).then(function(urls) {
    return new Set(urls);
  });
}

self.addEventListener('install', function(event) {
  event.waitUntil(
    caches.open(cacheName).then(function(cache) {
      return setOfCachedUrls(cache).then(function(cachedUrls) {
        return Promise.all(
          Array.from(urlsToCacheKeys.values()).map(function(cacheKey) {
            // If we don't have a key matching url in the cache already, add it.
            if (!cachedUrls.has(cacheKey)) {
              return cache.add(new Request(cacheKey, {
                credentials: 'same-origin',
                redirect: 'follow'
              }));
            }
          })
        );
      });
    }).then(function() {
      
      // Force the SW to transition from installing -> active state
      return self.skipWaiting();
      
    })
  );
});

self.addEventListener('activate', function(event) {
  var setOfExpectedUrls = new Set(urlsToCacheKeys.values());

  event.waitUntil(
    caches.open(cacheName).then(function(cache) {
      return cache.keys().then(function(existingRequests) {
        return Promise.all(
          existingRequests.map(function(existingRequest) {
            if (!setOfExpectedUrls.has(existingRequest.url)) {
              return cache.delete(existingRequest);
            }
          })
        );
      });
    }).then(function() {
      
      return self.clients.claim();
      
    })
  );
});


self.addEventListener('fetch', function(event) {
  if (event.request.method === 'GET') {
    // Should we call event.respondWith() inside this fetch event handler?
    // This needs to be determined synchronously, which will give other fetch
    // handlers a chance to handle the request if need be.
    var shouldRespond;

    // First, remove all the ignored parameter and see if we have that URL
    // in our cache. If so, great! shouldRespond will be true.
    var url = stripIgnoredUrlParameters(event.request.url, ignoreUrlParametersMatching);
    shouldRespond = urlsToCacheKeys.has(url);

    // If shouldRespond is false, check again, this time with 'index.html'
    // (or whatever the directoryIndex option is set to) at the end.
    var directoryIndex = 'index.html';
    if (!shouldRespond && directoryIndex) {
      url = addDirectoryIndex(url, directoryIndex);
      shouldRespond = urlsToCacheKeys.has(url);
    }

    // If shouldRespond is still false, check to see if this is a navigation
    // request, and if so, whether the URL matches navigateFallbackWhitelist.
    var navigateFallback = 'index.html';
    if (!shouldRespond &&
        navigateFallback &&
        (event.request.mode === 'navigate') &&
        isPathWhitelisted([], event.request.url)) {
      url = new URL(navigateFallback, self.location).toString();
      shouldRespond = urlsToCacheKeys.has(url);
    }

    // If shouldRespond was set to true at any point, then call
    // event.respondWith(), using the appropriate cache key.
    if (shouldRespond) {
      event.respondWith(
        caches.open(cacheName).then(function(cache) {
          return cache.match(urlsToCacheKeys.get(url)).then(function(response) {
            if (response) {
              return response;
            }
            throw Error('The cached response that was expected is missing.');
          });
        }).catch(function(e) {
          // Fall back to just fetch()ing the request if some unexpected error
          // prevented the cached response from being valid.
          console.warn('Couldn\'t serve response for "%s" from cache: %O', event.request.url, e);
          return fetch(event.request);
        })
      );
    }
  }
});







