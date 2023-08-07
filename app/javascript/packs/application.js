// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

var jQuery = require("jquery")
global.$ = global.jQuery = jQuery;
window.$ = window.jQuery = jQuery;

require('bootstrap');
require('admin-lte');
require('../packs/select2.full.min.js');
require('../packs/owl.carousel.min.js');

import "@fortawesome/fontawesome-free/js/all";
require("../packs/lightgallery.min");
require("../packs/bootstrap-autocomplete.min");

// cookie
window.Cookies = require("../packs/cookie")

// stylesheets
require("../stylesheets/application.scss")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

window.apiurl = '/api/v1';
window.directUrl = '/home/direction'
window.detailUrl = '/map/places'
window.apiauthen = 'Bearer qUT17DipLFXwcb-28ZdQZ4WaCxGAljJ5hNmT9YLKMm8';
window.limit = 100;
