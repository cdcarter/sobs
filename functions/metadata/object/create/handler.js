'use strict';
var metadataLib = require('../../../lib/metadata');

module.exports.handler = function(event, context) {
  metadataLib.createObject(event, function(error, response) {
    return context.done(error, response);
  });
};
