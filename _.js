Schemas = {};

Knots = new Mongo.Collection('knots');

Schemas.Knot = new SimpleSchema({
  body: {
    type: String
  },

  claim: {
    type: [Object],
    optional: true
  },

  'claim.$.userId': {
    type: String,
    autoform: {
      type: "select",
      options: function(){
        return _.map(Meteor.users.find().fetch(), function(u){
          return {
            value: u._id,
            label: u.name()
          };
        })
      }
    }
  },

  'claim.$.patchId': {
    type: String,
    autoform: {
      type: "select",
      options: function(){
        return _.map(Patches.find().fetch(), function(u){
          return {
            value: u._id,
            label: u.displayName
          };
        })
      }
    }
  },

  relationId: {
    type: String,
    autoform: {
      type: "select",
      options: function(){
        return _.map(Relations.find().fetch(), function(u){
          return {
            value: u._id,
            label: u._id
          };
        })
      }
    }
  },

  createdAt: {
    type: Date,
    label: 'Date',
    defaultValue: new Date,
    autoValue: function() {
      if (this.isUpsert) {
        return {
          $setOnInsert: new Date
        };
      }
    }
  },

  createdBy: {
    type: String,
    regEx: SimpleSchema.RegEx.Id
  }

});

Knots.attachSchema(Schemas.Knot);

/////////////

Relations = new Mongo.Collection('relations');

Schemas.Relation = new SimpleSchema({
  displayName: {
    type: String
  },

  userIds: {
    type: Array,
    min: 1,
    autoform: {
      type: "select2",
      afFieldInput: {
        multiple: true
      },
      options: function(){
        return _.map(Meteor.users.find().fetch(), function(u){
          return {
            value: u._id,
            label: u.name()
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

/////////////

Badges = new Mongo.Collection('badges');

Schemas.Badge = new SimpleSchema({
  displayName: {type: String},

  userIds: {
    type: Array,
    optional: true,
    autoform: {
      type: "select2",
      afFieldInput: {
        multiple: true
      },
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

Badges.attachSchema(Schemas.Badge);

/////////////

Patches = new Mongo.Collection('patches');

Schemas.Patch = new SimpleSchema({
  displayName: {type: String}
});

Patches.attachSchema(Schemas.Patch);

/////////////

Meteor.users.helpers({
  name() {
    return this.emails[0].address
  }
});

/////////////

Knots.allow({
  insert: function(){return true;},
  update: function(){return true;},
  remove: function(){return true;}
});
