Meteor.publish 'users', ->
  Meteor.users.find()
Meteor.publish 'relations', ->
  thisUser = Meteor.users.findOne(@userId)
  if thisUser.admin
    Relations.find()
  else
    Relations.find(
      $or: [
        {open: true},
        {userIds: {$in: [@userId]}},
        {createdBy: @userId}
      ]
    )
Meteor.publish 'knots', ->
  Knots.find()
Meteor.publish 'badges', ->
  Badges.find()
Meteor.publish 'patches', ->
  Patches.find()

Meteor.methods
  'knots.insert': (knotLiteral) ->
    # Make sure the user is logged in before inserting a task
    if !@userId
      throw new (Meteor.Error)('not-authorized')
    else
      knotLiteral.createdBy = @userId
      console.log knotLiteral
      Knots.insert knotLiteral
  'relations.insert': (relationLiteral) ->
    # Make sure the user is logged in before inserting a task
    if !@userId
      throw new (Meteor.Error)('not-authorized')
    else
      relationLiteral.createdBy = @userId
      Relations.insert relationLiteral
