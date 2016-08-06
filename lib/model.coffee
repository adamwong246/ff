_.mixin merge: ->
  _.reduce arguments, ((list, obj) ->
    _.extend list, obj
  ), {}

@Schemas = {}

basicSchema =
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
    autoValue: -> if (@isInsert && !@isSet)
      if @isFromTrustedCode then @userId
      else Meteor.userId()

Schemas.Profile =
  bio:
    type: String
    autoform:
      rows: 10
  picture:
    type: String
    autoform:
      afFieldInput:
        type: 'fileUpload'
        collection: 'UserImages'
        label: 'Choose file'
  location:
    type: String
    autoform:
      type: 'map'
      afFieldInput:
        geolocation: true
        searchBox: true
        autolocate: true

Schemas.User = new SimpleSchema
  emails:
    type: [Object]
    optional: true
  "emails.$.address":
    type: String
    regEx: SimpleSchema.RegEx.Email
  "emails.$.verified":
    type: Boolean
  services:
    type: Object
    optional: true
    blackbox: true
  admin:
    type: Boolean
    optional: true
  createdAt:
    type: Date
    label: 'Date'
    autoValue: -> if ((@isInsert || @isUpsert) && !@isSet) then new Date
  profile:
    type: new SimpleSchema Schemas.Profile

Meteor.users.attachSchema(Schemas.User)

@Knots = new (Mongo.Collection)('knots')

Schemas.Knot = _.merge basicSchema,
  body:
    type: String
    autoform:
      rows: 10
  relationId:
    type: String
    autoform:
      type: 'select'
      options: ->
        _.map Relations.find().fetch(), (u) ->
          value: u._id
          label: u._id
  'claimedPatch':
    type: String
    optional: true
    autoform:
      type: 'select'
      options: ->
        _.map Patches.find().fetch(), (u) ->
          {
            value: u._id
            label: u.displayName
          }

Knots.attachSchema  new SimpleSchema(Schemas.Knot)

Schemas.Role = new SimpleSchema

@Relations = new (Mongo.Collection)('relations')
Schemas.Relation = new SimpleSchema(
  displayName: type: String
  open:
    type: Boolean
  createdBy:
    type: String
    regEx: SimpleSchema.RegEx.Id
    autoform:
      options: ->
        _.map Meteor.users.find().fetch(), (u) ->
          value: u._id
          label: u.name()
  members:
    type: [Object]
  'members.$._id':
     type: String
     autoform:
       # type: 'select2'
       # afFieldInput: multiple: true
       options: ->
         _.map Meteor.users.find().fetch(), (u) ->
           value: u._id
           label: u.name()
   'members.$.role':
     type: String
     optional: true
)
Relations.attachSchema Schemas.Relation

@Badges = new (Mongo.Collection)('badges')

Schemas.Badge = new SimpleSchema(
  displayName: type: String
  description: type: String
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
  'userIds.$': type: String
  picture:
    type: String
    autoform:
      afFieldInput:
        type: 'fileUpload'
        collection: 'BadgeImages'
        label: 'Choose file'
)
Badges.attachSchema Schemas.Badge

@Patches = new (Mongo.Collection)('patches')
Schemas.Patch = new SimpleSchema
  displayName: type: String
  description: type: String
  picture:
    type: String
    autoform:
      afFieldInput:
        type: 'fileUpload'
        collection: 'PatchImages'
        label: 'Choose file'

Patches.attachSchema Schemas.Patch

imageStore = new (FS.Store.GridFS)('images',
  mongoUrl: 'mongodb://127.0.0.1:3001/test/'
  maxTries: 1
  chunkSize: 1024 * 1024
)

@PatchImages = new (FS.Collection)('patchImages', stores: [ imageStore ])
@BadgeImages = new (FS.Collection)('badgeImages', stores: [ imageStore ])
@UserImages = new (FS.Collection)('userImages', stores: [ imageStore ])

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
PatchImages.allow
  insert: -> true
  download: -> true
  update: -> true
BadgeImages.allow
  insert: -> true
  download: -> true
  update: -> true
UserImages.allow
  insert: -> true
  download: -> true
  update: -> true
