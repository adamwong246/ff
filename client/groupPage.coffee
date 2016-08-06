Template.groupPage.helpers
  userProfileImageUrl: ->
    UserImages.findOne(Meteor.users.findOne(@createdBy).profile.picture).url()
  patchImageUrl: ->
    console.log @picture
    PatchImages.findOne(@picture).url()
  group: ->
    Groups.findOne _id: FlowRouter.getParam('_id')
  memberName: ->
    Meteor.users.findOne(@_id).name()
  createdByName: ->
    Meteor.users.findOne(@createdBy).name()
  email: ->
    @emails[0].address
  formId: ->
    'updateRelationForm-' + @_id
  messages: ->
    Messages.find groupId: @_id
  noMessages: ->
    Messages.find({groupId: @_id}).count() == 0
  creatorName: ->
    Meteor.users.findOne(@createdBy).name()
  claimedPatch: ->
    Patches.findOne(@claimedPatch)
  preMessage: ->
    groupId: @_id
    createdBy: Meteor.userId()
    createdAt: new Date
  insertMessageFormSchema: ->
    new SimpleSchema(Schemas.Message)
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
