var dynamo = require('./dynamo');

module.exports.createObject = function (event, callback) {
  event.key_prefix = 'SObject';
  event.label = event.name;
  var params = {
    TableName: dynamo.metadataTableName,
    Item: event
  };

  return dynamo.doc.put(params, function (error, data) {
    if (error) {
      callback(error);
    } else {
      var newSobject = { 'sobject' : params };
      callback(error, newSobject);
    }
  });
};

module.exports.index = function (event, callback) {
  var params = {
    TableName: dynamo.metadataTableName,
    FilterExpression: "#type = :sobject",
    ExpressionAttributeNames: {
      "#type": "type",
    },
    ExpressionAttributeValues: {
      ":sobject": "SObject"
   }
  }
  return dynamo.doc.scan(params, function (error, data) {
    if (error) {
      callback(error);
    } else {
      var items = data.Items;
      var newData = { 'sobjects' : items };
      callback(error, newData);
    }
  });
};
