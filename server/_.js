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

Meteor.methods({
  'knots.insert': function (knotLiteral) {
    // check(knotLiteral, Object);

    // Make sure the user is logged in before inserting a task
    if (! this.userId) {
      throw new Meteor.Error('not-authorized');
    } else {
     knotLiteral.createdBy = this.userId
     console.log(JSON.stringify(knotLiteral))
     Knots.insert(knotLiteral);
    }


  }
});
