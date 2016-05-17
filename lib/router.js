FlowRouter.route('/', {
  action: function() {
    BlazeLayout.render("layout", {content: "main"});
  }
});

FlowRouter.route('/users', {
  action: function() {
    BlazeLayout.render("layout", {content: "users"});
  }
});

FlowRouter.route('/relations', {
  action: function() {
    BlazeLayout.render("layout", {content: "relations"});
  }
});

FlowRouter.route('/relation/:_id', {
  action: function(params) {
    BlazeLayout.render("layout", {content: "relationPage"});
  }
});

FlowRouter.route('/badges', {
  action: function() {
    BlazeLayout.render("layout", {content: "badges"});
  }
});

FlowRouter.route('/patches', {
  action: function() {
    BlazeLayout.render("layout", {content: "patches"});
  }
});
