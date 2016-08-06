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
      _.map(@members, (user) ->
        user._id
      ), Meteor.userId()
    ) or @open
