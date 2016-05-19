@Schemas = {}
@Knots = new (Mongo.Collection)('knots')
Schemas.Knot = new SimpleSchema(
  body: type: String
  claim:
    type: [ Object ]
    optional: true
  'claim.$.userId':
    type: String
    autoform:
      type: 'select'
      options: ->
        _.map Meteor.users.find().fetch(), (u) ->
          {
            value: u._id
            label: u.name()
          }
  'claim.$.patchId':
    type: String
    autoform:
      type: 'select'
      options: ->
        _.map Patches.find().fetch(), (u) ->
          {
            value: u._id
            label: u.displayName
          }
  pinned:
    type: Boolean
    optional: true
  relationId:
    type: String
    autoform:
      type: 'select'
      options: ->
        _.map Relations.find().fetch(), (u) ->
          {
            value: u._id
            label: u._id
          }
  createdAt:
    type: Date
    label: 'Date'
    defaultValue: new Date
    autoValue: ->
      if @isUpsert
        return { $setOnInsert: new Date }
      return
  createdBy:
    type: String
    regEx: SimpleSchema.RegEx.Id
    autoValue: ->
      @userId
)
Knots.attachSchema Schemas.Knot

@Relations = new (Mongo.Collection)('relations')
Schemas.Relation = new SimpleSchema(
  displayName: type: String
  userIds:
    type: Array
    optional: true
    min: 1
    autoform:
      type: 'select2'
      afFieldInput: multiple: true
      options: ->
        _.map Meteor.users.find().fetch(), (u) ->
          {
            value: u._id
            label: u.name()
          }
  'userIds.$': type: String
  open: type: Boolean
  createdBy:
    type: String
    regEx: SimpleSchema.RegEx.Id
    autoValue: ->
      @userId
)
Relations.attachSchema Schemas.Relation

@Badges = new (Mongo.Collection)('badges')
Schemas.Badge = new SimpleSchema(
  displayName: type: String
  userIds:
    type: Array
    optional: true
    autoform:
      type: 'select2'
      afFieldInput: multiple: true
      options: ->
        _.map Meteor.users.find().fetch(), (u) ->
          {
            value: u._id
            label: u.emails[0].address
          }
  'userIds.$': type: String)
Badges.attachSchema Schemas.Badge

@Patches = new (Mongo.Collection)('patches')
Schemas.Patch = new SimpleSchema(displayName: type: String)
Patches.attachSchema Schemas.Patch

Meteor.users.helpers name: -> @emails[0].address
Relations.helpers open: -> @userIds.length > 0

Relations.allow
  insert: -> true
  update: -> true
  remove: -> true
Badges.allow
  insert: -> true
  update: -> true
  remove: -> true
Patches.allow
  insert: -> true
  update: -> true
  remove: -> true
Knots.allow
  insert: -> true
  update: -> true
  remove: -> true
