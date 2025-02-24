require("dotenv").config(); //

const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
const Dotenv = require('dotenv-webpack');
environment.plugins.prepend(
  'Dotenv', new Dotenv(),
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery',
    Popper: 'popper.js'
  })
)



module.exports = environment
