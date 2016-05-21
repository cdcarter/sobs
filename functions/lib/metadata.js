var dynamo = require('./dynamo');

module.exports.createObject = function (event, callback) {
  event.type = 'SObject';
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

module.exports.viewObject = function (event, callback) {
  event.type = 'SObject';
  var params = {
    TableName: dynamo.metadataTableName,
    Key:{
        "name": event.name,
        "type": "SObject"
    }
  };

  return dynamo.doc.get(params, function (error, data) {
    if (error) {
      callback(error);
    } else {
      callback(error, data["Item"]);
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
      var item = data.Items[0];
      callback(error, item);
    }
  });
};
