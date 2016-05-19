var AWS = require('aws-sdk');
var dynamoDb = new AWS.DynamoDB({});
module.exports.doc = new AWS.DynamoDB.DocumentClient({ service: dynamoDb });
module.exports.metadataTableName = process.env.SERVERLESS_PROJECT + '-metadata-' + process.env.SERVERLESS_STAGE;
module.exports.sobjectTableName = process.env.SERVERLESS_PROJECT + '-sobjects-' + process.env.SERVERLESS_STAGE;
