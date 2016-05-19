Meteor.publish 'users', ->
  Meteor.users.find()
Meteor.publish 'relations', ->
  Relations.find()
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
      Knots.insert knotLiteral
    return
  'relations.insert': (relationLiteral) ->
    # Make sure the user is logged in before inserting a task
    if !@userId
      throw new (Meteor.Error)('not-authorized')
    else
      relationLiteral.createdBy = @userId
      Relations.insert relationLiteral
    return
