Schemas = {};

Knots = new Mongo.Collection('knots');

Schemas.Knot = new SimpleSchema({
  body: {
    type: String
  },

  claim: {
    type: [Object]
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
    regEx: SimpleSchema.RegEx.Id,
    autoValue: function(){ return this.userId }
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

if (Meteor.isClient) {

  Meteor.subscribe('users');
  Meteor.subscribe('relations');
  Meteor.subscribe('knots');
  Meteor.subscribe('badges');
  Meteor.subscribe('patches');

  Template.main.helpers({
    relations: function() {
     return Relations.find( {
       userIds: {
         "$in": [Meteor.userId()]
       }
     }); }
  });

  Template.users.helpers({
    users: function() {
      return Meteor.users.find();
    },

    email: function() {
      if (this.emails.length) {
        return this.emails[0].address
      } else {
        return "";
      }

    }
  });

  Template.relations.helpers({
    relations: function() { return Relations.find(); },

    relationLink: function() { return "/relation/" + this._id; },
    relationName: function(){return this.displayName}
  });

  Template.relationChunk.helpers({
    link: function() { return "/relation/" + this._id; },
    formId: function(){return "updateRelationForm-" + this._id;}
  });

  Template.relationPage.helpers({
    relation: function() {
      return Relations.findOne({_id: FlowRouter.getParam("_id")});
    },

    knots: function() {
      return Knots.find({relationId: this._id})
    },

    creatorName: function(){
      return Meteor.users.findOne(this.createdBy).name();
    },

    claimaintName: function(){
      return Meteor.users.findOne(this.userId).name();
    },

    patchName: function(){
      return Patches.findOne(this.patchId).displayName
    }
  });

  Template.patches.helpers({
    patches: function() { return Patches.find(); },
    formId: function(){return "updatePatchForm-" + this._id;}
  });

  Template.badges.helpers({
    badges: function() { return Badges.find(); },
    formId: function(){return "updateBadgeForm-" + this._id;}
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

  Meteor.publish('knots', function(){
    return Knots.find();
  })

  Meteor.publish('badges', function(){
    return Badges.find();
  })

  Meteor.publish('patches', function(){
    return Patches.find();
  })

}
