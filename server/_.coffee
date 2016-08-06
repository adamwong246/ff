Meteor.publish 'users', ->
  Meteor.users.find()
Meteor.publish 'groups', ->
  thisUser = Meteor.users.findOne(@userId)
  if thisUser.admin
    Groups.find()
  else
    Groups.find(
      $or: [
        {open: true},
        {userIds: {$in: [@userId]}},
        {createdBy: @userId}
      ]
    )
Meteor.publish 'messages', ->
  Messages.find()
Meteor.publish 'badges', ->
  Badges.find()
Meteor.publish 'patches', ->
  Patches.find()
Meteor.publish 'patchImages', ->
  PatchImages.find()
Meteor.publish 'badgeImages', ->
  BadgeImages.find()
Meteor.publish 'userImages', ->
  UserImages.find()

Meteor.methods
  'messages.insert': (messageLiteral) ->
    if !@userId
      throw new (Meteor.Error)('not-authorized')
    else
      messageLiteral.createdBy = @userId
      console.log messageLiteral
      Messages.insert messageLiteral
  'groups.insert': (groupLiteral) ->
    if !@userId
      throw new (Meteor.Error)('not-authorized')
    else
      groupLiteral.createdBy = @userId
      Groups.insert groupLiteral
