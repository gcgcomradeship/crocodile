// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"
import "jquery"
import 'bootstrap'

// import "babel-preset-es2015"

// import "./jquery.min.js"
// import "https://maps.googleapis.com/maps/api/js?sensor=true"
// import "./google-api.js"
import "./jquery.isotope.min.js"
import "./jquery.themepunch.plugins.min.js"
import "./jquery.themepunch.revolution.min.js"
import "./jquery.prettyPhoto.js"
// import "@types/jquery.prettyphoto"
// import "./scroolto.js"
import "./settings.js"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
