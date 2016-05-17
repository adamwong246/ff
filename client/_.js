AutoForm.debug();

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
   }); },

  relationLink: function() { return "/relation/" + this._id; },

  badges: function() {
   return Badges.find( {
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
  },

  preKnot: function(){
    return {
     relationId: this._id,
     createdBy: Meteor.userId(),
     createdAt: new Date()
    };
  },

  insertKnotFormSchema: function(){
    return Schemas.Knot
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
