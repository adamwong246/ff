Schemas = {};
Relations = new Mongo.Collection('relations');

Schemas.Relation = new SimpleSchema({
  userIds: {
    type: Array,
    min: 1,
    autoform: {
      options: function(){
        return _.map(Meteor.users.find().fetch(), function(u){
          return {
            value: u._id,
            label: u.emails[0].address
          };
        })
      }
    }
  },

  "userIds.$": {
    type: String
  }

});

Relations.attachSchema(Schemas.Relation);

if (Meteor.isClient) {

  Session.setDefault('counter', 0);

  Meteor.subscribe('users');
  Meteor.subscribe('relations');

  Template.hello.helpers({
    counter: function () {
      return Session.get('counter');
    },

    users: function() {
      return Meteor.users.find();
    },

    email: function() {
      if (this.emails.length) {
        return this.emails[0].address
      } else {
        return "";
      }

    },

    relations: function() {
      return Relations.find();
    }
  });

  Template.hello.events({
    'click button': function () {
      // increment the counter when button is clicked
      Session.set('counter', Session.get('counter') + 1);
    }
  });
}

if (Meteor.isServer) {
  Meteor.startup(function () {
    // code to run on server at startup
  });

  Meteor.publish('users', function(){
    return Meteor.users.find();
  })

  Meteor.publish('relations', function(){
    return Relations.find();
  })

}
