// Generated by CoffeeScript 1.7.1
'use strict';
module.exports = function(app) {
  var upload;
  upload = require('jquery-file-upload-middleware');
  upload.configure({
    uploadDir: __dirname + '/public/uploads',
    uploadUrl: '/upload/img',
    imageVersions: {
      thumbnail: {
        width: 80,
        height: 80
      }
    }
  });
  app.use('/uploads', upload.fileHandler());
  require('./routes/cities')(app);
  return require('./routes/base')(app);
};
