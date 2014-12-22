
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("mailgunSendMail", function(request, response) {
  
  var Mailgun = require('mailgun');
Mailgun.initialize('sandbox71b8c19fdce34ba39252a357f7bcd4d7.mailgun.org', 'key-c2e36ca0b8c72241406a5ea05cdfbb98');
  
  Mailgun.sendEmail({
  to: request.params.email,
  from: "My Pics@picture.com",
  subject: "Hello from My Pics!",
  text: "Welcome!! using My Pics is great!"
}, {
  success: function(httpResponse) {
    console.log(httpResponse);
    response.success("Email sent!");
  },
  error: function(httpResponse) {
    console.error(httpResponse);
    response.error("Uh oh, something went wrong");
  }
});
});

