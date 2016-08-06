AutoForm.debug()
Meteor.subscribe 'users'
Meteor.subscribe 'relations'
Meteor.subscribe 'knots'
Meteor.subscribe 'badges'
Meteor.subscribe 'patches'
Meteor.subscribe 'patchImages'
Meteor.subscribe 'badgeImages'
Meteor.subscribe 'userImages'


Meteor.startup ->
  GoogleMaps.load({ v: '3', key: 'AIzaSyDjVfG_b37aEUqUcs19vHD8unQOH9BDfX0', libraries: 'geometry,places' })

user_IdOfPage = -> FlowRouter.getParam("_id")
userOfPage = -> Meteor.users.findOne(user_IdOfPage())

Template.main.helpers
  relations: ->
    Relations.find()
  users: ->
    Meteor.users.find()

Template.users.helpers
  users: ->
    Meteor.users.find()
  email: ->
    if @emails.length
      @emails[0].address
    else
      ''
  userProfileImage: ->
    UserImages.findOne(@profile.picture)

Template.relations.helpers
  relations: ->
    Relations.find()
  relationLink: ->
    '/relation/' + @_id
  relationName: ->
    @displayName
  insertRelationFormSchema: ->
    Schemas.Relation

Template.patches.helpers
  patches: ->
    Patches.find()
  formId: ->
    'updatePatchForm-' + @_id
  patchImage: ->
    PatchImages.findOne(@picture)
  canInsert: ->
    Meteor.user().admin

Template.patchPage.helpers
  patch: ->
    Patches.findOne FlowRouter.getParam("_id")
  patchImage: ->
    PatchImages.findOne(@picture)
  formId: ->
    'updatePatchForm-' + @_id
  canEdit: ->
    Meteor.user()?.admin

Template.badges.helpers
  badges: ->
    Badges.find()
  badgeImage: ->
    BadgeImages.findOne(@picture)
  canInsert: ->
    Meteor.user().admin

Template.badgePage.helpers
  badge: ->
    Badges.findOne FlowRouter.getParam("_id")
  badgeImage: ->
    BadgeImages.findOne(@picture)
  formId: ->
    'updateBadgeForm-' + @_id
  canEdit: ->
    Meteor.user()?.admin
