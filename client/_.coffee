AutoForm.debug()
Meteor.subscribe 'users'
Meteor.subscribe 'relations'
Meteor.subscribe 'knots'
Meteor.subscribe 'badges'
Meteor.subscribe 'patches'
Meteor.subscribe 'patchImages'
Meteor.subscribe 'badgeImages'
Meteor.subscribe 'userImages'

user_IdOfPage = -> FlowRouter.getParam("_id")
userOfPage = -> Meteor.users.findOne(user_IdOfPage())

Template.main.helpers
  relations: ->
    Relations.find()
  users: ->
    Meteor.users.find()

Template.profile.helpers
  canEdit: ->
    user_IdOfPage() == Meteor.userId()
  user: ->
    userOfPage()
  userProfileImage: ->
    UserImages.findOne(userOfPage().profile.picture)
  email: ->
    userOfPage().emails[0].address
  relations: ->
    Relations.find 'members.$._id': '$in': [ user_IdOfPage() ]
  relationLink: ->
    '/relation/' + @_id
  badges: ->
    Badges.find 'members.$._id': '$in': [ user_IdOfPage() ]
  pinnableKnots: ->
    Knots.find
      $and: [
        {claimedPatch: {$exists: true}},
        {createdBy: user_IdOfPage()}
      ]
  possiblePatch: ->
    Patches.findOne(@claimedPatch)
  myPatches: ->
    Patches.find
      _id:
        $in: _.map Knots.find(
          {$and: [
            {claimedPatch: {$exists: true}},
            {createdBy: user_IdOfPage()}
          ]},
          {_id: 1}
        ).fetch(), (k) -> k.claimedPatch

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

Template.relationPage.helpers
  userProfileImageUrl: ->
    UserImages.findOne(Meteor.users.findOne(@createdBy).profile.picture).url()
  patchImageUrl: ->
    console.log @picture
    PatchImages.findOne(@picture).url()
  relation: ->
    Relations.findOne _id: FlowRouter.getParam('_id')
  memberName: ->
    Meteor.users.findOne(@_id).name()
  createdByName: ->
    Meteor.users.findOne(@createdBy).name()
  email: ->
    @emails[0].address
  formId: ->
    'updateRelationForm-' + @_id
  knots: ->
    Knots.find relationId: @_id
  noKnots: ->
    Knots.find({relationId: @_id}).count() == 0
  creatorName: ->
    Meteor.users.findOne(@createdBy).name()
  claimedPatch: ->
    Patches.findOne(@claimedPatch)
  preKnot: ->
    relationId: @_id
    createdBy: Meteor.userId()
    createdAt: new Date
  insertKnotFormSchema: ->
    new SimpleSchema(Schemas.Knot)
  canEdit: ->
    @createdBy == Meteor.userId()
  canView: ->
    true
  canPost: ->
    _.include(
      _.map(@users, (user) ->
        user._id
      ), Meteor.userId()
    ) or @open

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
